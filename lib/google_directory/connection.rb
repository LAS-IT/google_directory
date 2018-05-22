require 'google/apis/admin_directory_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

require "google_directory/user_commands"

module GoogleDirectory

  # The GoogleDirectory, makes it easy to work with Google Directory.
  # @since 0.1.0
  #
  # @note Its important to have your oauth setup and its client_secret.json file downloaded in the root directory
  # @note You can also use environment variables to override google defaults as wanted.
  class Connection

    include GoogleDirectory::UserCommands

    # default settings from google for all users
    OOB_URI = ENV['OOB_URI'] || 'urn:ietf:wg:oauth:2.0:oob'
    CREDENTIALS_PATH = ENV['CREDENTIALS_PATH'] || File.join( Dir.home, '.credentials', "admin-directory_v1-ruby-accounts.yaml")

    # Get info the Google Cloud Admin
    # https://console.cloud.google.com/apis/ or
    # build using: https://developers.google.com/api-client-library/ruby/guide/aaa_client_secrets
    CLIENT_SECRETS_PATH = ENV['CLIENT_SECRETS_PATH'] || 'client_secret.json'

    # Scope options - https://www.googleapis.com/auth/admin.directory.user
    SCOPE = Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_USER

    # Initialize the API
    # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
    # https://github.com/google/google-api-ruby-client/issues/360

    # @note make connection to google directory services
    # @param service [Class] the default is: Google::Apis::AdminDirectoryV1::DirectoryService
    def initialize( service: Google::Apis::AdminDirectoryV1::DirectoryService )
      app_name ||= ENV['APPLICATION_NAME'] || 'google_cloud_app_name'
      @service   = service.new
      @service.client_options.application_name = app_name
      @service.authorization = authorize
    end

    # @note Run a command against Google Directory
    #
    # @param command [Symbol] choose command to perform these include: :user_get, :user_exists? (t/f), :user_create, :user_delete, :user_update & convience commands :user_suspend, :user_reactivate, :user_change_password
    # @param attributes [Hash] attributes needed to perform command
    # @return [Hash] formatted as: `{success: {command: :command, attributes: {primary_email: "user@domain"}, response: GoogleAnswer} }`
    def run( command:, attributes: {} )
      response  = { success: nil, error: nil }
      begin
        response[:success] = send( command, attributes: attributes )
      rescue Google::Apis::ClientError => error
        response[:error]   = {command: command, attributes: attributes,
                              error: error}
      end
      response
    end
    alias_method :execute, :run

    # # answer = GoogleDirectory.(command: :user_get, attributes: {primary_email: "btihen@las.ch"})
    # def self.call(service: Google::Apis::AdminDirectoryV1::DirectoryService,
    #               app_name: nil,
    #               command:, attributes: {} )
    #   new(service: service, app_name: app_name).
    #     run(command: command, attributes: attributes)
    # end

    private
    attr_reader :service
    ##
    # FROM:
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
