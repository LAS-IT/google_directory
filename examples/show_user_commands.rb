#!/usr/bin/env ruby -w

# run using:
# ./get_user.rb

require 'google_directory'

# connect to google
google = GoogleDirectory::Connection.new
puts "Google Connection Settings: \n#{google}"

# MULTI USER GETS
# ---------------

# return 10 users sorted by email address
response = google.run(action: :user_exists?,
                      attributes: {primary_email: "not_here@las.ch"})
puts "\nConfirm User Non-Existence: \n#{response}"

# return 5 users sorted by email address
response = google.run(action: :users_list,
                      attributes: { max_results: 5 })
puts "\nList 5 users: \n#{response}"

# SINGLE USER GETS
# ----------------

# check a single user - who exists
response = google.run(action: :user_get,
                      attributes: {primary_email: "lweisbecker@las.ch"})
puts "\nGet User Info: \n#{response}"

# confirm existence of user
response = google.run(action: :user_exists?,
                      attributes: {primary_email: "lweisbecker@las.ch"})
puts "\nConfirm User Exists: \n#{response}"

# check a single user - who doesn't exist
response = google.run(action: :user_get,
                      attributes: {primary_email: "apitemp@las.ch"})
puts "\nGet User Info: \n#{response}"

# confirm non-existence of user
response = google.run(action: :user_exists?,
                      attributes: {primary_email: "apitemp@las.ch"})
puts "\nConfirm User non-Exists: \n#{response}"


# SINGLE USER CHANGES
# -------------------

# create new user
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
# create new user - works
response = google.run(action: :user_create,
                      attributes: {primary_email: "apitemp@las.ch"})
puts "\nConfirm User Create Works: \n#{response}"

# create new user - fails
response = google.run(action: :user_create,
                      attributes: {primary_email: "apitemp@las-test.ch"})
puts "\nConfirm User Create Fails: \n#{response}"

# - 

# add name to user - works
response = google.run(  action: :user_update,
                        attributes:{
                          primary_email: "apitemp@las.ch",
                          name: { given_name: 'API', family_name: 'TEMP'}
                      } )
puts "\nConfirm User Created: \n#{response}"

# add name to user - fails


# -

# activate user - works
response = google.run(action: :user_reactivate,
                      attributes: {primary_email: "apitemp@las.ch"})
puts "\nConfirm User Activated: \n#{response}"

# activate user - fails


# -

# suspend user - works
response = google.run(action: :user_suspend,
                      attributes: {primary_email: "apitemp@las.ch"})
puts "\nConfirm User Activated: \n#{response}"

# suspend user - fails


# -

# delete user - works
response = google.run(action: :user_delete,
                      attributes: {primary_email: "apitemp@las.ch"})
puts "\nConfirm User Delete Works: \n#{response}"

# delete user - fails
response = google.run(action: :user_delete,
                      attributes: {primary_email: "apitemp@las.ch"})
puts "\nConfirm User Delete Fails: \n#{response}"
