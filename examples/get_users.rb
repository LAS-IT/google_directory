#!/usr/bin/env ruby -w

# run using:
# ./get_user.rb

require 'google_directory'

# connect to google
google = GoogleDirectory::Connection.new


# list users
response = google.run(command: :user_get,
                      attributes: {primary_email: "btihen@las.ch"})

# see results
puts response
