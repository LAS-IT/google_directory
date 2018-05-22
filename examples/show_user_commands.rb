#!/usr/bin/env ruby -w

# run using:
# ./get_user.rb

require 'google_directory'

# connect to google
google = GoogleDirectory::Connection.new
puts "Google Connection Settings: \n#{google.inspect}"

# SINGLE USER GETS
# ----------------

# check a single user - who exists
google.run(command: :user_get, attributes: {primary_email: "btihen@las.ch"})
# => {:success=>
#   {:command=>:users_get,
#    :user=>"btihen@las.ch",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007fdf7867ac28
#      @addresses=
#       [{"type"=>"work",
#         "formatted"=>"Building: Beau Lieu; 2-1     ",
#         "streetAddress"=>"Building: Beau Lieu; 2-1",
#         "primary"=>true}],
#      @agreed_to_terms=true,
#      @aliases=
#       ["bill@las.ch",
#        "admin@las.ch",
#        "administrator@las.ch",
#        "wtihen@las.ch",
#        "alpinedesigners@las.ch",
#        "alpinedesigns@las.ch"],
#      @change_password_at_next_login=false,
#      @creation_time=#<DateTime: 2011-05-05T12:33:18+00:00 ((2455687j,45198s,0n),+0s,2299161j)>,
#      @customer_id="C01lzp9pc",
#      @emails=
#       [{"address"=>"admin@las.ch"},
#        {"address"=>"administrator@las.ch"},
#        {"address"=>"alpinedesigners@las.ch"},
#        {"address"=>"alpinedesigns@las.ch"},
#        {"address"=>"bill@las.ch"},
#        {"address"=>"btihen@las.ch", "primary"=>true},
#        {"address"=>"wtihen@las.ch"}],
#      @etag="\"LW8ywR8igJCaw6tx8gAGB-fySsA/f7jarAx7oxams74xSQT0HAR9A3k\"",
#      @external_ids=[{"value"=>"9981", "type"=>"organization"}],
#      @gender={"type"=>"male"},
#      @id="107761501808060553761",
#      @include_in_global_address_list=true,
#      @ip_whitelisted=false,
#      @is_admin=true,
#      @is_delegated_admin=false,
#      @is_enforced_in2_sv=false,
#      @is_enrolled_in2_sv=true,
#      @is_mailbox_setup=true,
#      @kind="admin#directory#user",
#      @last_login_time=#<DateTime: 2018-05-08T07:06:59+00:00 ((2458247j,25619s,0n),+0s,2299161j)>,
#      @name=
#       #<Google::Apis::AdminDirectoryV1::UserName:0x00007fdf793f5ab0
#        @family_name="TIHEN",
#        @full_name="Bill TIHEN",
#        @given_name="Bill">,
#      @org_unit_path="/IT",
#      @organizations=[{"name"=>"LAS", "primary"=>true, "customType"=>"work", "department"=>"IT"}],
#      @phones=
#       [{"value"=>"4817", "type"=>"work"},
#        {"value"=>"+41 24 493 4603", "type"=>"home"},
#        {"value"=>"+41 79 376 3281", "type"=>"mobile"}],
#      @primary_email="btihen@las.ch",
#      @suspended=false,
#      @thumbnail_photo_etag="\"LW8ywR8igJCaw6tx8gAGB-fySsA/-KlBXnIopTTii8VLuWDK_MpdqoE\"",
#      @thumbnail_photo_url=
#       "https://plus.google.com/_/focus/photos/public/AIbEiAIAAABDCKG0gYjbmJnbayILdmNhcmRfcGhvdG8qKDU4MWJlNjg1NmViZDU5ZTc3ODRkOTg1YjY0YWViZDgyNmY2MjdiY2IwATSNfPE5fw1URPuILPds0uIMK0US">},
#  :error=>nil}

# confirm existence of user
google.run(command: :user_exists?, attributes: {primary_email: "lweisbecker@las.ch"})
# => {:success=>{:command=>:user_exists?, :user=>"lweisbecker@las.ch", :response=>true}, :error=>nil}


# check a single user - who doesn't exist
google.run(command: :user_get, attributes: {primary_email: "apitemp@las.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_get,
#    :attributes=>{:primary_email=>"apitemp@las.ch"},
#    :error=>"#<Google::Apis::ClientError: notFound: Resource Not Found: userKey>"}}

# confirm non-existence of user
google.run(command: :user_exists?, attributes: {primary_email: "apitemp@las.ch"})
# => {:success=>{:command=>:user_exists?, :user=>"apitemp@las.ch", :response=>false}, :error=>nil}

# error when asking about another domain
google.run(command: :user_get, attributes: {primary_email: "apitemp@not-ours.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_get,
#    :attributes=>{:primary_email=>"apitemp@not-ours.ch"},
#    :error=>"#<Google::Apis::ClientError: forbidden: Not Authorized to access this resource/api>"}}


# error when asking about another domain
google.run(command: :user_exists?, attributes: {primary_email: "apitemp@not-ours.com"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_exists?,
#    :attributes=>{:primary_email=>"apitemp@not-ours.com"},
#    :error=>"#<Google::Apis::ClientError: forbidden: Not Authorized to access this resource/api>"}}


# SINGLE USER CHANGES
# -------------------

# create new user
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/User
# user_attr = {
#   :primary_email => 'apitemp@las.ch',
#   :name => {
#     :given_name => 'Nicola',
#     :family_name => 'COTTOM',
#   },
#   :org_unit_path => "/EMPLOYEE",
#   :suspended => true,
#   :password => 'n-42080-c',
#   :change_password_at_next_login => true,
# }

# create new user - not name info
user_attr = {primary_email: "apitemp@las.ch"}
google.run(command: :user_create, attributes: user_attr)
# => {:success=>nil,
#  :error=>
#   {:command=>:user_create,
#    :attributes=>{:primary_email=>"apitemp@las.ch"},
#    :error=>"#<Google::Apis::ClientError: invalid: Invalid Given/Family Name: FamilyName>"}}

# create new user - create with random password
user_attr = { primary_email: "apitemp@las.ch", :name => {:given_name => 'Api', :family_name => 'TEMP'} }
google.run(command: :user_create, attributes: user_attr)
# => {:success=>
#   {:command=>:user_create,
#    :user=>"apitemp@las.ch",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f859d041558
#      @change_password_at_next_login=true,
#      @creation_time=#<DateTime: 2018-05-22T07:20:55+00:00 ((2458261j,26455s,0n),+0s,2299161j)>,
#      @customer_id="C01lzp9pc",
#      @etag="\"LW8ywR8igJCaw6tx8gAGB-fySsA/Y98NMYgpSFWufCMhUE_HvE1OiCA\"",
#      @id="115395847643072686155",
#      @is_admin=false,
#      @is_delegated_admin=false,
#      @is_mailbox_setup=false,
#      @kind="admin#directory#user",
#      @name=#<Google::Apis::AdminDirectoryV1::UserName:0x00007f85986f3928 @family_name="TEMP", @given_name="Api">,
#      @org_unit_path="/",
#      @primary_email="apitemp@las.ch",
#      @suspended=true,
#      @suspension_reason="ADMIN">},
#  :error=>nil}


# create duplicate user error
user_attr = { primary_email: "apitemp@las.ch", :name => {:given_name => 'Api', :family_name => 'TEMP'} }
google.run(command: :user_create, attributes: user_attr)
# => {:success=>nil,
#  :error=>
#   {:command=>:user_create,
#    :attributes=>{:primary_email=>"apitemp@las.ch", :name=>{:given_name=>"Api", :family_name=>"TEMP"}},
#    :error=>"#<Google::Apis::ClientError: duplicate: Entity already exists.>"}}


# create new user - fails
google.run(command: :user_create, attributes: {primary_email: "apitemp@not-ours.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_create,
#    :attributes=>{:primary_email=>"apitemp@not-ours.ch"},
#    :error=>"#<Google::Apis::ClientError: notFound: Domain not found.>"}}

# -

# change password - works
user_attr = { primary_email: "apitemp@las.ch", password: '34rfgb6yhjm' }
google.run( command: :user_update, attributes:user_attr )
# => {:success=>
#   {:command=>:user_update,
#    :user=>"apitemp@las.ch",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f85995574d8
#      @agreed_to_terms=true,
#      @change_password_at_next_login=true,
#      @creation_time=#<DateTime: 2018-05-22T07:20:55+00:00 ((2458261j,26455s,0n),+0s,2299161j)>,
#      @customer_id="C01lzp9pc",
#      @emails=[{"address"=>"apitemp@las.ch", "primary"=>true}],
#      @etag="\"LW8ywR8igJCaw6tx8gAGB-fySsA/6NgoiIjYFZImFylcQasrrk7HBok\"",
#      @id="115395847643072686155",
#      @include_in_global_address_list=true,
#      @ip_whitelisted=false,
#      @is_admin=false,
#      @is_delegated_admin=false,
#      @is_mailbox_setup=true,
#      @kind="admin#directory#user",
#      @last_login_time=#<DateTime: 1970-01-01T00:00:00+00:00 ((2440588j,0s,0n),+0s,2299161j)>,
#      @name=
#       #<Google::Apis::AdminDirectoryV1::UserName:0x00007f859795c4b8
#        @family_name="TEMP",
#        @full_name="Api TEMP",
#        @given_name="Api">,
#      @org_unit_path="/",
#      @primary_email="apitemp@las.ch",
#      @suspended=true,
#      @suspension_reason="ADMIN">},
#  :error=>nil}

# add name to user - fails


# -

# activate user - works
google.run(command: :user_reactivate, attributes: {primary_email: "apitemp@las.ch"})
# => {:success=>
#   {:command=>:user_reactivate,
#    :user=>"apitemp@las.ch",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f859d82ab98
#      @agreed_to_terms=true,
#      @change_password_at_next_login=true,
#      @creation_time=#<DateTime: 2018-05-22T07:20:55+00:00 ((2458261j,26455s,0n),+0s,2299161j)>,
#      @customer_id="C01lzp9pc",
#      @emails=[{"address"=>"apitemp@las.ch", "primary"=>true}],
#      @etag="\"LW8ywR8igJCaw6tx8gAGB-fySsA/Zhc5O8lo7X7XZR68Tb8LGd-ARdY\"",
#      @id="115395847643072686155",
#      @include_in_global_address_list=true,
#      @ip_whitelisted=false,
#      @is_admin=false,
#      @is_delegated_admin=false,
#      @is_mailbox_setup=true,
#      @kind="admin#directory#user",
#      @last_login_time=#<DateTime: 1970-01-01T00:00:00+00:00 ((2440588j,0s,0n),+0s,2299161j)>,
#      @name=
#       #<Google::Apis::AdminDirectoryV1::UserName:0x00007f859d846b18
#        @family_name="TEMP",
#        @full_name="Api TEMP",
#        @given_name="Api">,
#      @org_unit_path="/",
#      @primary_email="apitemp@las.ch",
#      @suspended=false>},
#  :error=>nil}

# activate non-existent user
google.run(command: :user_reactivate, attributes: {primary_email: "api-temp@las.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_reactivate,
#    :attributes=>{:primary_email=>"api-temp@las.ch"},
#    :error=>"#<Google::Apis::ClientError: notFound: Resource Not Found: userKey>"}}

# activate user in another domain
google.run(command: :user_reactivate, attributes: {primary_email: "api-temp@not-ours.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_reactivate,
#    :attributes=>{:primary_email=>"api-temp@not-ours.ch"},
#    :error=>"#<Google::Apis::ClientError: forbidden: Not Authorized to access this resource/api>"}}


# -

# suspend user - works
google.run(command: :user_suspend, attributes: {primary_email: "apitemp@las.ch"})
# => {:success=>
#   {:command=>:user_suspend,
#    :user=>"apitemp@las.ch",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f8599adc1d8
#      @agreed_to_terms=true,
#      @change_password_at_next_login=true,
#      @creation_time=#<DateTime: 2018-05-22T07:20:55+00:00 ((2458261j,26455s,0n),+0s,2299161j)>,
#      @customer_id="C01lzp9pc",
#      @emails=[{"address"=>"apitemp@las.ch", "primary"=>true}],
#      @etag="\"LW8ywR8igJCaw6tx8gAGB-fySsA/8SdYYQmRP0PVtK8s0HUtcoMQoJ4\"",
#      @id="115395847643072686155",
#      @include_in_global_address_list=true,
#      @ip_whitelisted=false,
#      @is_admin=false,
#      @is_delegated_admin=false,
#      @is_mailbox_setup=true,
#      @kind="admin#directory#user",
#      @last_login_time=#<DateTime: 1970-01-01T00:00:00+00:00 ((2440588j,0s,0n),+0s,2299161j)>,
#      @name=
#       #<Google::Apis::AdminDirectoryV1::UserName:0x00007f8599acf410
#        @family_name="TEMP",
#        @full_name="Api TEMP",
#        @given_name="Api">,
#      @org_unit_path="/",
#      @primary_email="apitemp@las.ch",
#      @suspended=true,
#      @suspension_reason="ADMIN">},
#  :error=>nil}

# suspend non-existent user - fails
google.run(command: :user_suspend, attributes: {primary_email: "api-temp@las.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_suspend,
#    :attributes=>{:primary_email=>"api-temp@las.ch"},
#    :error=>"#<Google::Apis::ClientError: notFound: Resource Not Found: userKey>"}}

# suspend user in another Domain
google.run(command: :user_suspend, attributes: {primary_email: "api-temp@not-las.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_suspend,
#    :attributes=>{:primary_email=>"api-temp@not-las.ch"},
#    :error=>"#<Google::Apis::ClientError: forbidden: Not Authorized to access this resource/api>"}}


# -

# delete user - works
google.run(command: :user_delete, attributes: {primary_email: "apitemp@las.ch"})
# => {:success=>{:command=>:user_delete, :user=>"apitemp@las.ch", :response=>""}, :error=>nil}


# delete user - already deleted
google.run(command: :user_delete, attributes: {primary_email: "apitemp@las.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_delete,
#    :attributes=>{:primary_email=>"apitemp@las.ch"},
#    :error=>"#<Google::Apis::ClientError: notFound: Resource Not Found: userKey>"}}

# error when deleting a user in another domain
google.run(command: :user_delete, attributes: {primary_email: "apitemp@notlas.ch"})
# => {:success=>nil,
#  :error=>
#   {:command=>:user_delete,
#    :attributes=>{:primary_email=>"apitemp@notlas.ch"},
#    :error=>"#<Google::Apis::ClientError: forbidden: Not Authorized to access this resource/api>"}}
