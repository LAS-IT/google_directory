# GoogleDirectory

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/google_directory`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_directory'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_directory

## Change Log

* **0.1.0** - *2018-05-22* - initial release 

## Usage
```ruby
# configure
# Use environmental variables
# BE SURE TO DOWNLOAD client_secret.json from:
# https://console.cloud.google.com/apis/
###########

# connect using
google = GoogleDirectory::Connection.new

##############
# VIEW USERS
# ------------
# get user details
google.run(action: :user_get, attributes: {primary_email: "user@domain.com"})
# => {:success=>
#   {:action=>:users_get,
#    :user=>"user@domain.com",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007fdea5d542c0
#      ...
#      @primary_email="user@domain.com",
#      @suspended=false>},
#  :error=>nil}

google.run(action: :user_exists?, attributes: {primary_email: "user@domain.com"})
# => {:success=>{:action=>:user_exists?, :user=>"user@domain.com", :response=>true}, :error=>nil}

# confirm non-existence of user
google.run(action: :user_exists?, attributes: {primary_email: "notuser@domain.com"})
# => {:success=>{:action=>:user_exists?, :user=>"notuser@domain.com", :response=>false}, :error=>nil}

##############
# USER CHANGES
# ------------
# user attributes can be found at:
# https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/User
# user_attr = {
#   :primary_email => 'seeuser@las.ch',
#   :name => {
#     :given_name => 'See',
#     :family_name => 'USER',
#   },
#   :org_unit_path => "/",
#   :suspended => true,
#   :password => 'some-secret',
#   :change_password_at_next_login => true,
# }

# create new user - not name info
user_attr = {primary_email: "apitemp@las.ch"}
google.run(action: :user_create, attributes: user_attr)
# => {:success=>nil,
#  :error=>
#   {:action=>:user_create,
#    :attributes=>{:primary_email=>"apitemp@las.ch"},
#    :error=>"#<Google::Apis::ClientError: invalid: Invalid Given/Family Name: FamilyName>"}}

# create new user - with random password - suspended by default
user_attr = { primary_email: "new@domain.com", :name => {:given_name => 'New', :family_name => 'USER'} }
google.run(action: :user_create, attributes: user_attr)
# => {:success=>
#   {:action=>:user_create,
#    :user=>"new@domain.com",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f859d041558
#      @change_password_at_next_login=true,
#      @creation_time=#<DateTime: 2018-05-22T07:20:55+00:00 ((2458261j,26455s,0n),+0s,2299161j)>,
#      ...
#      @primary_email="new@domain.com",
#      @suspended=true,
#      @suspension_reason="ADMIN">},
#  :error=>nil}

# update user settings
user_attr = { primary_email: "changed@domain.com", org_unit_path: "/" }
google.run( action: :user_update, attributes: user_attr )
# => {:success=>
#   {:action=>:user_update,
#    :user=>"changed@domain.com",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f85995574d8
#      ...
#      @org_unit_path="/",
#      @primary_email="changed@domain.com"},
#  :error=>nil}

# activate user
google.run(action: :user_reactivate, attributes: {primary_email: "active@domain.com"})
# => {:success=>
#   {:action=>:user_reactivate,
#    :user=>"active@domain.com",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f859d82ab98
#     ...
#      @primary_email="active@domain.com",
#      @suspended=false>},
#  :error=>nil}

# suspend user
google.run(action: :user_suspend, attributes: {primary_email: "suspended@domain.com"})
# => {:success=>
#   {:action=>:user_suspend,
#    :user=>"suspended@domain.com",
#    :response=>
#     #<Google::Apis::AdminDirectoryV1::User:0x00007f8599adc1d8
#      ...
#      @suspended=true,
#      @suspension_reason="ADMIN">},
#  :error=>nil}

# delete user - works
google.run(action: :user_delete, attributes: {primary_email: "byebye@domain.com"})
# => {:success=>{:action=>:user_delete, :user=>"byebye@domain.com", :response=>""}, :error=>nil}

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


#### Useful Dev DOCS

**Sample Auth Code & Other Suite Tools**

- Official Getting Started: https://developers.google.com/admin-sdk/directory/v1/quickstart/ruby
- Good Auth Examples: https://developers.google.com/youtube/v3/code_samples/ruby
- Gem usage docs: https://github.com/google/google-api-ruby-client
- Google Scope Options: https://www.googleapis.com/auth/admin.directory.user
- API for Directory (accounts): https://developers.google.com/admin-sdk/directory/v1/guides/manage-users#get_user
- DirectoryService Ruby API Commands: https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
- Create a new user attributes (also read code to understand how its used): https://github.com/google/google-api-ruby-client/issues/360 and

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/google_directory. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GoogleDirectory project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/google_directory/blob/master/CODE_OF_CONDUCT.md).
