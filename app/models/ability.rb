
class Ability
  include Hydra::Ability
  include Hydra::PolicyAwareAbility
  include Sufia::Ability



# Overriden from hydra-head/hydra-access-controls/lib/hydra/ability.rb
# Restricts access to OSU Registered viewable items from registered users who are not OSU related.
  def user_groups
    return @user_groups if @user_groups

    @user_groups = default_user_groups
    @user_groups |= current_user.groups if current_user and current_user.respond_to? :groups
    @user_groups |= ['registered'] if !current_user.new_record? && current_user.is_osu
    @user_groups
  end

  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end

    # TODO: This area looks like it needs to be refactored.

    if current_user.admin?
      editor_abilities
      upload_abilities
      publish_abilities
      roles_abilities
      hard_delete_abilities
      import_admin_abilities
      user_abilities
      group_abilities
      can [:create, :destroy, :update], FeaturedWork
      can [:manage], Hydra::Admin::Collection

      can :create, TinymceAsset
      can [:create, :update], ContentBlock
      can :read, ContentBlock
      can :characterize, GenericFile
    end


    if current_user.manager?
      upload_abilities
      publish_abilities
      roles_abilities
      import_user_abilities
      can [:manage], Hydra::Admin::Collection do |admin_set|
        # Can manage admin sets within their assigned unit.
        current_user.osul_groups.include? admin_set.unit_group
      end
      can [:manage], Osul::Group do |group|
        # Can manage the groups the user is in or the groups of the units a user is assigned to.
        current_user.osul_groups.include? group or current_user.osul_groups.include? group.unit
      end
      can [:create], Osul::Group
      can [:create, :destroy, :update], FeaturedWork
    end

    if current_user.data_entry?
      upload_abilities
      publish_abilities
      no_admin_set_abilities
    end

    if current_user.data_entry_student?
      upload_abilities
      no_admin_set_abilities
    end

    unless current_user.public?
      can :view_full, GenericFile
    end

    if current_user.role.nil?
      no_file_abilities
      no_admin_set_abilities
    end
  end

  def publish_abilities
    can [:publish], GenericFile
  end

  def upload_abilities
    can [:create], ActiveFedora::Base
  end

  def roles_abilities
    #can [:create, :show, :add_user, :remove_user, :index, :edit], Role
    can [:index, :edit, :add_user, :remove_user], Role
  end

  def hard_delete_abilities
    can [:manage], TrashedItem
  end

  def group_abilities
    can [:manage], Osul::Group
  end

  def import_user_abilities
    can :create, Import
    can [:read, :row_preview, :image_preview], Import, user_id: current_user.id
    can :start, Import, status: 'ready', user_id: current_user.id
    can [:undo, :finalize], Import, status: 'complete', user_id: current_user.id
    can :resume, Import do |import|
      import.user_id == current_user.id && import.is_resumable?
    end
    can [:update, :destroy, :browse], Import do |import|
      import.user_id == current_user.id && import.is_editable?
    end
    can :report, Import do |import|
      import.user_id == current_user.id && import.is_reportable?
    end
  end

  def import_admin_abilities
    can [:create, :read, :row_preview, :image_preview, :view_all], Import
    can :start, Import, status: 'ready'
    can [:undo, :finalize], Import, status: 'complete'
    can :resume, Import do |import|
      import.is_resumable?
    end
    can [:update, :destroy, :browse], Import do |import|
      import.is_editable?
    end
    can :report, Import do |import|
      import.is_reportable?
    end
  end

  # DEFINED UPSTREAM (Sufia::Ability) AS self 
  # def user_abilities
  #   can [:manage], User
  # end

  def no_admin_set_abilities
    cannot [:edit, :create, :delete], Hydra::Admin::Collection
  end

  def no_file_abilities
    cannot [:edit, :create, :delete], GenericFile
  end


end
