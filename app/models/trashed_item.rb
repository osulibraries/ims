class TrashedItem < ActiveRecord::Base
  def generic_file
    GenericFile.find generic_file_id rescue nil
  end

  def collection
    Hydra::Admin::Collection.find collection_id rescue nil
  end

  def delete
    gf = GenericFile.find generic_file_id
    gf.destroy
    destroy
  end

  def restore
    gf = GenericFile.find generic_file_id
    gf.update depositor: depositor, visibility: visibility, collection_id: collection_id
    destroy
  end
end
