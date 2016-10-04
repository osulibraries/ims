module Osul
  class Group < ActiveRecord::Base
    has_many :group_users, class_name: "Osul::GroupUser", foreign_key: "group_id"
    has_many :users, :through => :group_users

    belongs_to :unit, foreign_key: "unit_id", class_name: "Osul::Group"
    has_many :groups, foreign_key: "unit_id", class_name: "Osul::Group", :dependent => :nullify 

    accepts_nested_attributes_for :users
    accepts_nested_attributes_for :group_users

    # case_sensitive: false actually means you want to check the case.
    validates :name, presence: true, uniqueness: {case_sensitive: false}
    validates :unit_id, presence: true, unless: "is_unit"
    after_create :generate_key

    scope :units, -> {where(is_unit: true).where.not(name: "Administrators")}

    private
    def generate_key
      self.update(key: key_from_name)
    end

    def key_from_name
      self.name.gsub(/[^0-9a-z ]/i, '').gsub(' ', '')
    end

    def name_is_unique
      self.name
    end

  end
end
