require "spec_helper"

RSpec.describe GoogleDirectory::Connection do

  let!( :google ) { GoogleDirectory::Connection.new }

  it "connects to google" do
    answer  = google.send(:service).send(:client_options).send(:application_name)
    correct = ENV['APPLICATION_NAME']
    expect( answer ).to eq( correct )
  end

  it "errors when can't connect to google"
  
end
