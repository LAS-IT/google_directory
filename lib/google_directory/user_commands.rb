module GoogleDirectory
  module UserCommands

    def user_get( attributes: )
      service.get_user( attributes[:primary_email] )
    end

  end
end
