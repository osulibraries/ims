class MintHandleJob
  @queue = :imports

  def self.perform (file_id)
    file = GenericFile.find file_id
    HandleService.new(file).mint
  end
end