class UndoImportJob
  @queue = :imports

  def self.perform (import_id, user_id)
    import = Import.find import_id
    user = User.find user_id
    BatchImportService.new(import, user).revert_records
  end
end
