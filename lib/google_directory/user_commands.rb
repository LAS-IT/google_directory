module GoogleDirectory

  # DirectoryService Ruby API Commands
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
  module UserCommands

    # Usage hints
    # https://github.com/google/google-api-ruby-client/issues/360

    # get multiple users
    # if you don't want the defaults { max_results: 10, order_by: 'email' }
    # you must override (a nil disables the option)
    def users_list( attributes: {} )
      defaults = { max_results: 10, order_by: 'email' }
      filters  = defaults.merge( attributes )
      response = service.list_users( filters, attributes[:options] )
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_get( attributes: )
      service.get_user( attributes[:primary_email], attributes[:options] )
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_exists?( attributes: )
      begin
        service.get_user( attributes[:primary_email], attributes[:options] )
        return true
      rescue Google::Apis::ClientError => error
        return false if error.messages.include? 'notFound'
        raise error
      end
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_create( attributes: )
      defaults  = { :suspended => true, :change_password_at_next_login => true }
      user_attr = defaults.merge( attributes )
      # create a user object that google will create
      user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # send the user with attributes to google to create account
      response = service.insert_user( user_object, attributes[:options] )
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_update( attributes: )
      # create a user object for google to update
      user_object = Google::Apis::AdminDirectoryV1::User.new attributes
      # update user
      response = service.update_user( attributes[:primary_email], user_object, attributes[:options] )
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_reactivate( attributes: )
      defaults  = { :suspended => false }
      user_attr = defaults.merge( attributes )
      # create a user object that google will create
      user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # update user
      response = service.update_user( attributes[:primary_email], user_object, attributes[:options] )
    end

    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_suspend( attributes: )
      defaults  = { :suspended => true }
      user_attr = defaults.merge( attributes )
      # create a user object that google will create
      user_object = Google::Apis::AdminDirectoryV1::User.new user_attr
      # update user
      response = service.update_user( attributes[:primary_email], user_object, attributes[:options] )
    end
    
    # this attribute MUST include: { primary_email: "username@las.ch" }
    def user_delete( attributes: )
      response = service.delete_user( attributes[:primary_email], attributes[:options] )
    end

  end
end
