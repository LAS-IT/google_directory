require "spec_helper"

RSpec.describe GoogleDirectory::Version do
  it "has a version number" do
    # expect(VERSION).not_to be nil
    expect(GoogleDirectory::Version::VERSION).not_to be nil
  end

  it "has correct version number" do
    expect(GoogleDirectory::Version::VERSION).to eq '0.2.2'
  end
end
