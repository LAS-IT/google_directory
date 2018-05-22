#!/usr/bin/env ruby

# run using:
# ./create_users.rb

require 'google_directory'

# Be sure to put a client_secret.json file from google in this directory

# connect to google
google = GoogleDirectory::Connection.new

# USERS #
#########
users_file = 'users-sample.yml' if File.file?('users-sample.yml')
users_file = 'users.yml'        if File.file?('users.yml') # real
users_file ||= nil
#
users = nil
begin
  users  = YAML.load( File.open(users_file) )
rescue ArgumentError => e
  puts "YAML Error: #{e.message}"
end                        unless users_file.nil?
# sample minimal user information (actually password isn't needed)
# users ||= [
#             { primary_email: "username@domain.com",
#               password: "password",
#               name: { given_name: "First Names",
#                       family_name: "FAMILY NAMES"}
#             }
#           ]
# File.write("users-sample.yml",users.to_yaml)
puts "\nUSERS:"
pp users

# # CONFIRM #
# ###########
# add is this what you expect?
puts "Review the user data \nEnter 'Y' to create Google accounts"
answer = gets.chomp.downcase
puts "aborting account creation"  unless answer.eql? 'y'
exit                              unless answer.eql? 'y'
puts "creating Google accounts ..."

# # CREATE #
# ##########
puts "\nGoogle Create Commands:"
users.each do |person|
  puts "Creating #{attributes[:primary_email]}"
  pp google.run(command: user_create, attributes: person)
end                               unless users.nil?
