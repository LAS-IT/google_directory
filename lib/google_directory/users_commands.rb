# already required in Google API
# require 'SecureRandom'

module GoogleDirectory

  # DirectoryService Ruby API Commands
  # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
  module UsersCommands

    # Usage hints
    # https://github.com/google/google-api-ruby-client/issues/360

    # get multiple users
    # if you don't want the defaults { max_results: 10, order_by: 'email' }
    # you must override (a nil disables the option)
    def users_list( attributes: {} )
      defaults = { max_results: 10, order_by: 'email' }
      filters  = defaults.merge( attributes )
      response = service.list_users( filters )
      {action: :users_list, filters: filters, response: response}
    end

  end
end
