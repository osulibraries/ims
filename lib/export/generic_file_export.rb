require "./lib/export/export.rb"
module Export
  class GenericFileExport < ExportBase

    def terms
      #removed visibility b/c it's coming from solr :visibility
      [:id, :date_uploaded, :identifier, :resource_type, :title, :creator, :contributor, :description, :bibliographic_citation, :tag,
       :rights, :provenance, :publisher, :date_created, :subject, :language, :based_near, :related_url,
       :work_type, :spatial, :alternative, :temporal, :format, :staff_notes, :source, :part_of, :preservation_level_rationale,
       :preservation_level, :collection_identifier, :collection_id, :depositor, :handle,
       :batch_id, :collection_id, :admin_policy_id, :filename, :unit]
    end

    def complex_terms
      []#[:materials, :measurements]
    end

    # This will export all generic_files minus measurements and materials
    def export_all_gfs
      starting_point = Osul::Export::ExportGenericFileItem.count
      Osul::Export::CategorizeExportList.where(resource_type: "GenericFile").offset(starting_point).each_with_index do |item, i|
        next if item.fid == "g7330k20p"
        puts "index #{i}"
        puts item.fid
        id = item.fid
        export_single_item(id)
      end
    end

    def export_single_gf(id)
        export_single_item(id)      
    end


    def export_vra_measurements
      Osul::Export::CategorizeExportList.where(resource_type: "Osul::VRA::Measurement").each_with_index do |item, i|
        puts "index #{i}"
        puts item.fid 

        measurement = ActiveFedora::Base.find item.fid
        puts measurement.generic_file_id
        gid = measurement.generic_file_id

        begin
          export = Osul::Export::ExportGenericFileItem.find_by(fid: gid)
          unless export.measurements.include?(measurement.attributes)
            export.measurements << measurement.attributes
            export.save
          end
        rescue
          puts 'rescued last item'
          next 
        end
      end
    end

    def export_vra_materials
      Osul::Export::CategorizeExportList.where(resource_type: "Osul::VRA::Material").each_with_index do |item, i|
        puts "index #{i}"
        puts item.fid 
        
        material = ActiveFedora::Base.find item.fid
        puts material.generic_file_id
        gid = material.generic_file_id
        begin
          export = Osul::Export::ExportGenericFileItem.find_by(fid: gid)
          unless export.materials.include?(material.attributes)
            export.materials << material.attributes
            export.save
          end
        rescue
          puts 'rescued last item'
          next 
        end
      end
    end

    private
      def export_single_item(id)
        #Get generic_file from fedora
        g = GenericFile.find id

        h = {}  #reset content of row array
        #loop through each term and call the corresponding method to get the data
        terms.each do |t|
          h[t] = g.send(t)
        end

        #loop through each complex object and call the corresponding methods to get the data
        complex_terms.each do |ct|
          comp_term_arr = []
          g.send(ct).to_a.each do |complex_term|
            comp_term_arr << complex_term.attributes
          end
          h[ct] = comp_term_arr
        end

        #get the image uri and store it
        h.delete(:id)
        h[:image_uri] = g.content.uri.path
        h[:fid] = g.id
        Osul::Export::ExportGenericFileItem.create!(JSON.parse(h.to_json))
      end
  end
end
