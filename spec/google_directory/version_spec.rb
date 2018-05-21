require "spec_helper"

RSpec.describe GoogleDirectory::Version do
  it "has a version number" do
    # expect(VERSION).not_to be nil
    expect(GoogleDirectory::Version::VERSION).not_to be nil
  end

  it "has correct version number" do
    # expect(VERSION).not_to be '0.1.0'
    expect(GoogleDirectory::Version::VERSION).not_to be '0.1.0'
  end
end
