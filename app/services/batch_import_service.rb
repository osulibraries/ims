class BatchImportService
  def initialize(import, user)
    @import = import
    @user = user
  end

  def schedule
    return false unless @import.ready?
    Resque.enqueue(ImportJob, @import.id, @user.id)
    @import.in_progress!
  end

  def process(start_at = nil)
    options ={headers: @import.includes_headers? ? true : false}

    CSV.foreach(@import.csv_file_path, options ).each_with_index do |row, i|
      current_row = @import.includes_headers? ? i + 2 : i + 1
      next unless start_at.nil? || current_row > start_at

      csv_style_array = []
      row.each do |arr| csv_style_array << arr end
      csv_row_array = []
      csv_style_array.each do |arr| csv_row_array << arr.last end
      Resque.enqueue(ProcessImportItem, @import.id, csv_row_array, @user.id, current_row)
    end
  end

  def import_item(row, current_row)
    begin
      generic_file = ingest row
      record = ImportedRecord.find_or_create_by(import_id: @import.id, csv_row: current_row, generic_file_pid: generic_file.id)
      record.update(success: true)

    rescue => e
      Rails.logger.error "------import ingest saving error------"
      Rails.logger.error e
      record = ImportedRecord.find_or_create_by(import_id: @import.id, csv_row: current_row)
      record.update(success: false, message: e.message)
    end

    # import has finished - set import status to complete
    @import.complete! if @import.all_records_imported?
  end

  def resume
    return false unless @import.is_resumable?
    Resque.enqueue(ImportJob, @import.id, @user.id, @import.imported_records.last.try(:csv_row))
    @import.in_progress!
  end

  def undo
    @import.reverting!
    Resque.enqueue(UndoImportJob, @import.id, @user.id)
  end

  def revert_records
    @import.imported_records.each do |record|
      Resque.enqueue(DestroyImportedRecordJob, record.id, @user.id)
    end
  end

  def destroy_record(record)
    record.completely_destroy_file!
    record.destroy
    @import.ready! if @import.reload.imported_records.size.zero?
  end

  def finalize
    return false unless @import.complete?
    @import.final!
    Resque.enqueue(ScheduleMintingJob, @import.id, @user.id)
  end

  def mint
    @import.imported_records.each do |record|
      Resque.enqueue(MintHandleJob, record.file.id) if record.file.present?
    end
  end


  private

  def ingest(row)
    filename = get_filename_from row
    basename = File.basename(filename)
    image_path = @import.image_path_for filename
    raise "File #{filename} was not found." unless File.file? image_path

    # Ingest files already on disk
    generic_file = ::GenericFile.new(label: basename).tap do |gf|
      gf.relative_path = filename if filename != basename
      actor = Sufia::GenericFile::Actor.new(gf, @user)
      actor.create_metadata @import.batch_id
      gf.collection_id = @import.admin_collection_id

      assign_csv_values_to_genericfile(row, gf)
      gf.rights = [@import.rights]
      gf.preservation_level_rationale = @import.preservation_level
      gf.preservation_level = "Full"
      gf.visibility = @import.visibility
      gf.save!

      Sufia.queue.push(IngestLocalImportFileJob.new(gf.id, image_path, @user.user_key))
    end
  end

  def get_filename_from(row)
    filename_column_number = @import.import_field_mappings.where(key: 'image_filename').first.value
    filename = row[filename_column_number.last.to_i]
    raise 'filename cannot be blank' if filename.blank?
    filename
  end

  # Maps a specific row of csv data to a generic_file object for ingest
  def assign_csv_values_to_genericfile(row, generic_file)
    field_mappings = @import.import_field_mappings.where('import_field_mappings.key != ?', 'image_filename')
    field_mappings.each do |field_mapping|

      key_column_number_arr = @import.import_field_mappings.where(key: field_mapping.key).first.value.reject!{|a| a.blank? } 
      key_column_value_arr = []

      # For certain fields the values in the csv are comma delimeted and need to be parsed
      if field_mapping.key == 'subject'
        key_column_number_arr.each do |num|
          key_column_value_arr = key_column_value_arr + (row[num.to_i].try(:split, ',') || [])
        end
      elsif field_mapping.key == 'collection_identifier'
        # it's not a multivalue field so let's just get the first mapping
        key_column_number_arr.each do |num|
          generic_file.collection_identifier = row[num.to_i]
          break
        end

      elsif field_mapping.key == 'measurements'
        key_column_number_arr.each do |num|
          measurement_hash = measurement_format_for(row[num.to_i].try(:strip))
          unless measurement_hash.nil?
            #insert field as a measurement object
            measurement = Osul::VRA::Measurement.create(measurement: measurement_hash[:width], measurement_unit: measurement_hash[:unit], measurement_type: "width")    
            
            generic_file.measurements << measurement
            measurement = Osul::VRA::Measurement.create(measurement: measurement_hash[:height], measurement_unit: measurement_hash[:unit], measurement_type: "height")    
            generic_file.measurements << measurement
          end
        end

      elsif field_mapping.key == 'materials'
        key_column_number_arr.each do |num|
          material_hash = material_format_for(row[num.to_i].try(:strip))
          unless material_hash.nil?
            material = Osul::VRA::Material.create(material_hash)
            generic_file.materials << material
          end
        end

      else
        key_column_number_arr.each do |num|
          key_column_value_arr << row[num.to_i]
        end
      end

      # materials and measurements are associations so they are updated differently 
      unless field_mapping.key == 'materials' or field_mapping.key == 'measurements' or field_mapping.key == 'collection_identifier'
        key_column_value_arr = key_column_value_arr.map.reject{|a| a.blank?}
        generic_file.send("#{field_mapping.key}=".to_sym, key_column_value_arr)
      end
    end
  end

  def measurement_format_for(field_value)
    # format (34.5 x 54.34 cm)
    match_result = /\A(\d*\.?\d+)[[:space:]]x[[:space:]](\d*\.?\d+)[[:space:]](mm|cm|m|in|ft)\Z/.match(field_value)
    unless match_result.nil?
      result = {:height => match_result[1], :width => match_result[2], :unit => match_result[3]}
    end
    result
  end

  def material_format_for(value)
    # format paper (parchment)
    # material (type-optional)
    match_result = /\A([^\s]+)\s*(?:\((.+)\))?\Z/.match(value)
    unless match_result.nil?
      result = { material: match_result[1] }
      result[:material_type] = match_result[2] unless match_result[2].nil?
    end
    result
  end

end
