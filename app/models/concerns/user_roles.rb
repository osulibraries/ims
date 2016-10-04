module UserRoles
  extend ActiveSupport::Concern

  included do
    belongs_to :role
  end


  def admin?
    has_role? "admin"
  end

  def manager?
    has_role? "Manager"
  end

  def data_entry?
    has_role? "Data-Entry"
  end

  def data_entry_student?
    has_role? "Data-Entry, Student"
  end

  def privileged_viewer
    has_role? "Privileged Viewer"
  end

  def public?
    self.role.blank?
  end


  private
    def has_role?(role)
      self.role.try(:name) == role
    end

end
