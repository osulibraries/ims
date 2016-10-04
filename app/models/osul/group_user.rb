module Osul
  class GroupUser < ActiveRecord::Base
    belongs_to :group, class_name: 'Osul::Group', foreign_key: 'group_id'
    belongs_to :user
    after_create :user_group_list

    private
    def user_group_list
      self.user.update_user_group_list
    end

    
  end
end
