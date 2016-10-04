class ImportedRecord < ActiveRecord::Base
  include FedoraObjectAssociations

  belongs_to :import

  belongs_to_fedora :file, foreign_key: 'generic_file_pid', class_name: 'GenericFile'

  def completely_destroy_file!
    if file.present?
      file.destroy
      file.eradicate
    end
  end

end
