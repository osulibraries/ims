class UpdateMembers
  attr_accessor :admin_collection_id

  def queue
    :event
  end

  def initialize(admin_collection_id)
    self.admin_collection_id = admin_collection_id
  end

  def run
    collection = Hydra::Admin::Collection.find(self.admin_collection_id)
    collection.members.each do |member|
      member.save
    end
  end
end