class DestroyImportedRecordJob
  @queue = :imports

  def self.perform(record_id, user_id)
    record = ImportedRecord.includes(:import).find(record_id)
    user = User.find user_id
    BatchImportService.new(record.import, user).destroy_record(record)
  end
end