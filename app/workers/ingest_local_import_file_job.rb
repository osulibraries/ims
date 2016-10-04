class IngestLocalImportFileJob
  attr_accessor :path, :user_key, :generic_file_id

  def queue_name
    :ingest
  end

  def initialize(generic_file_id, path, user_key)
    self.generic_file_id = generic_file_id
    self.path = path
    self.user_key = user_key
  end

  def run
    user = User.find_by_user_key(user_key)
    raise "Unable to find user for #{user_key}" unless user

    filename = File.basename(path)
    generic_file = GenericFile.find(generic_file_id)
    actor = Sufia::GenericFile::Actor.new(generic_file, user)

    if actor.create_content(File.open(path), filename, 'content', mime_type(filename))
      Sufia.queue.push(ContentDepositEventJob.new(generic_file.id, user_key))
      Rails.logger.info "Local file ingest: The file (#{filename}) was successfully deposited"
    else
      Rails.logger.error "Local file ingest error: There was a problem depositing (#{filename})"
    end
  end

  def job_user
    User.batchuser
  end

  def mime_type(file_name)
    mime_types = MIME::Types.of(file_name)
    mime_types.empty? ? "application/octet-stream" : mime_types.first.content_type
  end
end
