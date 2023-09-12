require 'googleauth'
require 'google/apis/admin_directory_v1'
require 'fileutils'
require "google_directory/version"
require "google_directory/user_commands"

module GoogleDirectory

  # The GoogleDirectory, makes it easy to work with Google Directory.
  # @since 0.1.0
  #
  # @note Its important to have your oauth setup and its client_secret.json file downloaded in the root directory
  # @note You can also use environment variables to override google defaults as wanted.
  class Connection

    include GoogleDirectory::Version
    include GoogleDirectory::UserCommands

    # default settings from google for all users
    CREDENTIALS_PATH = ENV['CREDENTIALS_JSON_PATH']
    SUB_ACCOUNT = ENV['SUB_ACCOUNT_NAME']

    # Get info the Google Cloud Admin
    # https://console.cloud.google.com/apis/ or
    # build using: https://developers.google.com/api-client-library/ruby/guide/aaa_client_secrets
    # CLIENT_SECRETS_PATH = ENV['CLIENT_SECRETS_PATH'] || 'client_secret.json'

    # Scope options - https://www.googleapis.com/auth/admin.directory.user
    # https://developers.google.com/admin-sdk/directory/v1/guides/authorizing
    # SCOPE = Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_USER
    # SCOPE = 'https://www.googleapis.com/auth/admin.directory.user'

    # Initialize the API
    # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/DirectoryService
    # https://github.com/google/google-api-ruby-client/issues/360

    # @note make connection to google directory services
    # @param service [Class] the default is: Google::Apis::AdminDirectoryV1::DirectoryService
    def initialize( service: Google::Apis::AdminDirectoryV1::DirectoryService )
      @service   = service.new
      @service.authorization = authorize
    end

    def version
      VERSION
    end

    # @param command [Symbol] choose command to perform these include: :user_get, :user_exists? (t/f), :user_create, :user_delete, :user_update & convience commands :user_suspend, :user_reactivate, :user_change_password
    # @param attributes [Hash] attributes needed to perform command
    # @return [Hash] formatted as: `{success: {command: :command, attributes: {primary_email: "user@domain"}, response: GoogleAnswer} }`
    def run( command:, attributes: {} )
      response  = {}
      begin
        response           = send( command, attributes: attributes )
        response[:status]  = 'success'
      rescue Google::Apis::ClientError => error
        response = {status: 'error', response: error,
                    attributes: attributes, command: command,
                   }
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

    def authorize
      scope = ['https://www.googleapis.com/auth/admin.directory.user', 'https://www.googleapis.com/auth/admin.directory.user.security']
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(CREDENTIALS_PATH),
        scope: scope)
      authorizer.update!(sub: SUB_ACCOUNT)
      authorizer.fetch_access_token!
      return authorizer
    end
  end
end
