require 'google/apis/admin_directory_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

require "google_directory/user_commands"

module GoogleDirectory
  class Connection

    attr_reader :response

    include GoogleDirectory::UserCommands

    # Get from the Google Cloud Admin
    # https://console.cloud.google.com/apis/
    # APPLICATION_NAME = ENV['APPLICATION_NAME'] || 'cloud_admin_name'
    # BE SURE TO PUT YOUR SECRET TOKEN in the file: client_secret.json
    # available to download from the cloud admin page or build it using:
    #  build using: https://developers.google.com/api-client-library/ruby/guide/aaa_client_secrets
    CLIENT_SECRETS_PATH = 'client_secret.json'
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    CREDENTIALS_PATH = File.join( Dir.home, '.credentials', "admin-directory_v1-ruby-accounts.yaml")

    # Scope options - https://www.googleapis.com/auth/admin.directory.user
    SCOPE = Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_USER

    # Initialize the API
    # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
    # https://github.com/google/google-api-ruby-client/issues/360
    def initialize( service: Google::Apis::AdminDirectoryV1::DirectoryService,
                    app_name: nil )

      @response  = { successes: [], errors: [] }

      app_name ||= ENV['APPLICATION_NAME'] || 'google_cloud_admin_name'
      @service   = service.new
      @service.client_options.application_name = app_name
      @service.authorization = authorize
    end

    # google = GoogleDirectory.new
    # answer = google.run(action: :user_get, attributes: {primary_email: "btihen@las.ch"})
    def run( action:, attributes: {} )
      begin
        @response[:successes] << send( action, attributes: attributes )
      rescue Google::Apis::ClientError => error
        @response[:errors] << error.message
      end
      response
    end
    alias_method :execute, :run

    # answer = GoogleDirectory.(action: :user_get, attributes: {primary_email: "btihen@las.ch"})
    def self.call(service: Google::Apis::AdminDirectoryV1::DirectoryService,
                  app_name: nil,
                  action:, attributes: {} )
      new(service: service, app_name: app_name).
        run(action: action, attributes: attributes)
    end

    private
    attr_reader :service
    ##
    #
    # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

      client_id   = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      authorizer  = Google::Auth::UserAuthorizer.new( client_id, SCOPE, token_store )
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(
          base_url: OOB_URI)
        puts "Open the following URL in the browser and enter the " +
             "resulting code after authorization"
        puts url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI)
      end
      credentials
    end
  end
end
