# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!([
 {email: "test@test.com", password: "password", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2015-03-10 18:14:43", last_sign_in_at: "2015-03-10 18:14:43", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", guest: false, facebook_handle: nil, twitter_handle: nil, googleplus_handle: nil, display_name: nil, address: nil, admin_area: nil, department: nil, title: nil, office: nil, chat_id: nil, website: nil, affiliation: nil, telephone: nil, avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, group_list: nil, groups_last_update: nil, linkedin_handle: nil, orcid: nil, currently_osu: nil}
  ])
# User::HABTM_Roles.create!([
#   {role_id: 1, user_id: 1}
#   #{role_id: 2, user_id: 3}
# ])
Osul::Group.create!([
  {name: "Administrators", description: "IMS Administrators", key: "Administrators", is_unit: true, unit_id: nil},
  {name: "Billy Ireland Cartoon Library & Museum", description: "Billy Ireland Cartoon Library & Museum", key: "BillyIrelandCartoonLibraryMuseum", is_unit: true, unit_id: nil},
  {name: "The Hilandar Research Library", description: "The Hilandar Research Library", key: "TheHilandarResearchLibrary", is_unit: true, unit_id: nil},
  {name: "Calvin & Hobbes", description: "Calvin & Hobbes", key: "CalvinHobbes", is_unit: false, unit_id: 1}
])
Osul::GroupUser.create!([
  {user_id: 1, group_id: 3},
  #{user_id: 3, group_id: 3},
  #{user_id: 3, group_id: 1},
  {user_id: 1, group_id: 1}
])

Role.create!([
  {name: "admin"},
  {name: "Manager"},
  {name: "Data-Entry"},
  {name: "Data-Entry, Student"},
  {name: "Privileged Viewer"}
])

