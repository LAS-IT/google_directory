require "spec_helper"

RSpec.describe GoogleDirectory::Connection do

  # let!( :google ) { GoogleDirectory::Connection.new }

  it "connects to google" do
    google = GoogleDirectory::Connection.new
    answer  = google.send(:service).send(:client_options).send(:application_name)
    correct = ENV['APPLICATION_NAME']
    expect( answer ).to eq( correct )
  end

  # it "errors when can't connect to google" do
  #   ENV['CLIENT_SECRETS_PATH']="no_client_secret.json"
  #   google = GoogleDirectory::Connection.new
  #   pp google
  #   answer  = google.send(:service).send(:client_options).send(:application_name)
  #   correct = ENV['APPLICATION_NAME']
  #   expect( answer ).not_to eq( correct )
  # end
end
