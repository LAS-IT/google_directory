require "spec_helper"

RSpec.describe GoogleDirectory::Connection do

  it "connects to google" do
    expect { GoogleDirectory::Connection.new }.not_to raise_error()
  end
  it "with a invalid app_name" do
    stub_const('ENV', ENV.to_hash.merge('APPLICATION_NAME' => 'another_app_name'))
    expect { GoogleDirectory::Connection.new }.not_to raise_error()
    # google = GoogleDirectory::Connection.new
    # answer  = google.send(:service).send(:client_options).send(:application_name)
    # correct = 'another_app_name'
    # expect( answer ).to eq( correct )
  end

  context "connection presents version" do
    it "matches version module" do
      version = GoogleDirectory::Version::VERSION
      google  = GoogleDirectory::Connection.new
      expect( google.version ).to eql( version )
    end
  end

  context "fails to connect to google" do
    it "without a client_secret.json" do
      stub_const("GoogleDirectory::Connection::CLIENT_SECRETS_PATH", "spec/data/client_secret_no_file.json")
      expect { GoogleDirectory::Connection.new }.to raise_error(Errno::ENOENT, /No such file or directory/)
      # "Errno::ENOENT: No such file or directory @ rb_sysopen - no_client_secret.json"
    end
    it "with an empty client_secret.json" do
      stub_const("GoogleDirectory::Connection::CLIENT_SECRETS_PATH", "spec/data/client_secret_empty.json")
      expect { GoogleDirectory::Connection.new }.to raise_error(MultiJson::ParseError, /JSON::ParserError/)
      # "MultiJson::ParseError: JSON::ParserError"
    end
    it "with a invalid client id in client_secret.json" do
      stub_const("GoogleDirectory::Connection::CLIENT_SECRETS_PATH", "spec/data/client_secret_invalid.json")
      expect { GoogleDirectory::Connection.new }.to raise_error(RuntimeError, /does not match configured client id/)
      # "RuntimeError: Token client ID of xxxxxxxxx-zzzzzzzzzzzzxxxxxxxxxxxxxxx.apps.googleusercontent.com does not match configured client id 000000000000-zzz0000z0z00zzz0zzzz0z0zz00zzz0z.apps.googleusercontent.com"
    end
  end
end
