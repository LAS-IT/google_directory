# already required in Google API
# require 'SecureRandom'

module GoogleDirectory

  # DirectoryService Ruby API Commands
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
  module UserCommands

    # Usage hints
    # https://github.com/google/google-api-ruby-client/issues/360

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_get( attributes: )
      response = service.get_user( attributes[:primary_email] )
      {action: :users_get, user: attributes[:primary_email], response: response}
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_exists?( attributes: )
      begin
        response = service.get_user( attributes[:primary_email] )
        return {action: :user_exists?, user: attributes[:primary_email], response: true}
      rescue Google::Apis::ClientError => error
        if error.message.include? 'notFound'
          return {action: :user_exists?, user: attributes[:primary_email], response: false}
        else
          raise error
        end
      end
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_create( attributes: )
      # http://blog.liveedu.tv/ruby-generate-random-string/
      password = SecureRandom.base64
      defaults  = { suspended: true, password: password, change_password_at_next_login: true }
      user_attr = defaults.merge( attributes )
      # create a google user object
      user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # create user in directory services
      response = service.insert_user( user_object )
      {action: :user_create, user: attributes[:primary_email], response: response}
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_update( attributes: )
      # create a user object for google to update
      response = update_user( attributes )
      # user_object = Google::Apis::AdminDirectoryV1::User.new attributes
      # # update user
      # response = service.update_user( attributes[:primary_email], user_object )
      {action: :user_update, user: attributes[:primary_email], response: response}
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_change_password( attributes: )
      # http://blog.liveedu.tv/ruby-generate-random-string/
      password = SecureRandom.base64
      defaults  = { password: password, change_password_at_next_login: true }
      user_attr = defaults.merge( attributes )

      response = update_user( user_attr )
      # # create a user object that google will create
      # user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # # update user in directory
      # response = service.update_user( attributes[:primary_email], user_object )
      {action: :user_change_password, user: attributes[:primary_email], response: response}
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_reactivate( attributes: )
      defaults  = { :suspended => false }
      user_attr = defaults.merge( attributes )

      response = update_user( user_attr )
      # # create a user object that google will create
      # user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # # update user
      # response = service.update_user( attributes[:primary_email], user_object )
      {action: :user_reactivate, user: attributes[:primary_email], response: response}
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_suspend( attributes: )
      defaults  = { :suspended => true }
      user_attr = defaults.merge( attributes )

      response = update_user( user_attr )
      # create a user object that google will create
      # user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # # update user
      # response = service.update_user( attributes[:primary_email], user_object )
      {action: :user_suspend, user: attributes[:primary_email], response: response}
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_delete( attributes: )
      response = service.delete_user( attributes[:primary_email] )
      {action: :user_delete, user: attributes[:primary_email], response: response}
    end

    private
    def update_user( user_attr )
      # create a user object that google will create
      user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # send user object to google directory
      service.update_user( user_attr[:primary_email], user_object )
    end

  end
end
