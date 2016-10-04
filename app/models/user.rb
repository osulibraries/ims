class User < ActiveRecord::Base
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Sufia behaviors. 
  include Sufia::User



  include UserRoles

  include Sufia::UserUsageStats
  has_many :group_users, class_name: "Osul::GroupUser"
  has_many :osul_groups, class_name: "Osul::Group", :through => :group_users, source: :group

  attr_accessible :email, :password, :password_confirmation if Rails::VERSION::MAJOR < 4
# Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.

  validate :osu_email, :on => :create


  def to_s
    email
  end
  
  def is_osu
    # TODO: Needs to be based off shibb vars somehow.
    self.currently_osu?
  end

  def is_member
    self.role.present? && !self.osul_groups.empty?
  end

  def osul_group_list
    self.osul_groups.each.collect { |g| g.key }.join(';?;')
  end

  def update_user_group_list
    self.update(:group_list => osul_group_list)
    self.save
  end

  def units
    (self.groups.include? "Administrators") ? Osul::Group.units : self.osul_groups.units
  end

  def admin_sets
    (self.groups.include? "Administrators") ? Hydra::Admin::Collection.all : unit_admin_sets
  end

  def unit_admin_sets
    sets = []
    units.each {|u| sets << Hydra::Admin::Collection.where(unit: u.key)}
    return sets.flatten
  end

  def directory
    "#{Rails.root}/imports/images/"
  end
  
  private

  def osu_email
    if (self.email.match /@osu.edu/).present? && !self.currently_osu?
      self.errors.messages[:email] = ["You cannot manually register with an OSU email. Please auto-register by using the OSU Login provided or manually register with another email address."]
    end
  end
end
