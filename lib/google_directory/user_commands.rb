# already required in Google API
# require 'SecureRandom'

module GoogleDirectory

  # @note DirectoryService Ruby API Commands - https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
  # @note GoogleUser Attributes - https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/User
  module UserCommands

    # @note Get GoogleDirectory User Info
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com" }
    # @return [Hash] formatted as {success: {action: :user_get, attributes: {primary_email: "user@domain"}, response: GoogleUserObject } }
    def user_get( attributes: )
      response = service.get_user( attributes[:primary_email] )
      {action: :user_get, user: attributes[:primary_email], response: response}
    end

    # @note Test if user exists in Google Directory
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com" }
    # @return [Hash] formatted as {success: {action: :user_exists?, attributes: {primary_email: "user@domain"}, response: Boolean } }
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

    # @note creates a new Google Directory User
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com", name: {given_name: "First Names", family_name: "LAST NAMES" } }
    # @return [Hash] formatted as {success: {action: :user_create, attributes: {primary_email: "user@domain"}, response: GoogleUserObject } }
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

    # @note updates an exising Google Directory User
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com", attributes_to_change: "" } }
    # @return [Hash] formatted as {success: {action: :user_update, attributes: {primary_email: "user@domain"}, response: GoogleUserObject } }
    def user_update( attributes: )
      # create a user object for google to update
      response = update_user( attributes )
      {action: :user_update, user: attributes[:primary_email], response: response}
    end

    # @note updates an exising Google Directory User password - convience method instead of using :user_update
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com", password: "secret" } - if no password is included a random password will be assigned
    # @return [Hash] formatted as {success: {action: :user_change_password, attributes: {primary_email: "user@domain"}, response: GoogleUserObject } }
    def user_change_password( attributes: )
      password = SecureRandom.base64
      defaults  = { password: password, change_password_at_next_login: true }
      user_attr = defaults.merge( attributes )

      response = update_user( user_attr )
      {action: :user_change_password, user: attributes[:primary_email], response: response}
    end

    # @note activates an exising Google Directory User password - convience method instead of using :user_update
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com" }
    # @return [Hash] formatted as {success: {action: :user_reactivate, attributes: {primary_email: "user@domain"}, response: GoogleUserObject } }
    def user_reactivate( attributes: )
      defaults  = { :suspended => false }
      user_attr = defaults.merge( attributes )

      response = update_user( user_attr )
      {action: :user_reactivate, user: attributes[:primary_email], response: response}
    end

    # @note suspends an exising Google Directory User password - convience method instead of using :user_update
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com" }
    # @return [Hash] formatted as {success: {action: :user_suspend, attributes: {primary_email: "user@domain"}, response: GoogleUserObject } }
    def user_suspend( attributes: )
      defaults  = { :suspended => true }
      user_attr = defaults.merge( attributes )

      response = update_user( user_attr )
      {action: :user_suspend, user: attributes[:primary_email], response: response}
    end

    # @note deletes an exising Google Directory User
    #
    # @param attributes [Hash] this attribute MUST include: { primary_email: "username@domain.com" }
    # @return [Hash] formatted as {success: {action: :user_delete, attributes: {primary_email: "user@domain"}, response: "" } }
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
