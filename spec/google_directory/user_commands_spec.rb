require "spec_helper"

RSpec.describe GoogleDirectory::UserCommands do

  let!(:google )      { GoogleDirectory::Connection.new }
  let( :valid_key)    { {primary_email: "lweisbecker@las.ch"} }
  let( :notuser_key)  { {primary_email: "notuser@las.ch"} }
  let( :newuser_key)  { {primary_email: "tempuser@las.ch"} }
  let( :bad_domain)   { {primary_email: "notlas@notlas.ch"} }
  let( :new_bad_attr) { {primary_email: "noattr@las.ch"} }
  let( :change_attr)  { {primary_email: "lweisbecker@las.ch",
                        name: { given_name: 'Lee',
                                family_name: 'Weisbecker'},
                        org_unit_path: "/IT"} }
  let( :new_attr)     { {primary_email: "tempuser@las.ch",
                        name: { given_name: 'Temp',
                                family_name: 'USER'},
                        org_unit_path: "/EMPLOYEE"} }
  let( :not_las_attr) { {primary_email: "nouser@notlas.ch",
                        name: { given_name: 'Temp',
                                family_name: 'USER'},
                        org_unit_path: "/EMPLOYEE"} }

  context "get info on a single user" do
    it "who exists" do
      answer  = google.run(command: :user_get, attributes: valid_key)
      correct = valid_key[:primary_email]
      expect( answer[:status] ).to eq( 'success' )
      expect( answer[:response].primary_email ).to eq( correct )
    end
    it "who doesn't exist" do
      answer  = google.run(command: :user_get, attributes: notuser_key)
      correct = "notFound: Resource Not Found: userKey"
      expect( answer[:status] ).to match( 'error' )
      expect( answer[:response].to_s ).to match( correct )
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_get, attributes: bad_domain)
      correct = "forbidden: Not Authorized to access this resource/api"
      expect( answer[:status] ).to match( 'error' )
      expect( answer[:response].to_s ).to match( correct )
    end
  end

  context "test if single user exists" do
    it "who exists" do
      answer  = google.run(command: :user_exists?, attributes: valid_key)
      expect( answer[:status] ).to match('success')
      expect( answer[:response].to_s ).to match('true')
    end
    it "who doesn't exist" do
      answer  = google.run(command: :user_exists?, attributes: notuser_key)
      expect( answer[:status] ).to match('success')
      expect( answer[:response].to_s ).to match('false')
      # expect( answer[:success][:response] ).to be_falsey
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_exists?, attributes: bad_domain)
      correct = "forbidden: Not Authorized to access this resource/api"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
  end

  context "test successful user creation" do
    after(:each) do
      google.run(command: :user_delete, attributes: new_attr)
    end
    it "with valid attributes" do
      start   = google.run(command: :user_exists?, attributes: new_attr)
      expect( start[:status] ).to match('success')
      expect( start[:response].to_s ).to match('false')
      answer  = google.run(command: :user_create, attributes: new_attr)
      correct = new_attr[:primary_email]
      expect( answer[:status] ).to eq( 'success' )
      expect( answer[:response].primary_email ).to eq( correct )
    end
  end
  context "test failing user creation" do
    it "with an existing user" do
      answer  = google.run(command: :user_create, attributes: change_attr)
      correct = "duplicate: Entity already exists."
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
    it "with incomplete attributes" do
      answer  = google.run(command: :user_create, attributes: new_bad_attr)
      correct = "invalid: Invalid Given/Family Name: FamilyName"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_create, attributes: not_las_attr)
      correct = "notFound: Domain not found."
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
  end

  context "update user attributes" do
    it "who exists" do
      answer  = google.run(command: :user_update, attributes: change_attr)
      expect( answer[:status] ).to match('success')
      expect( answer[:response].primary_email ).to match('lweisbecker@las.ch')
    end
    it "who doesn't exist" do
      answer  = google.run(command: :user_update, attributes: new_attr)
      correct = "notFound: Resource Not Found: userKey"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_update, attributes: not_las_attr)
      correct = "forbidden: Not Authorized to access this resource/api"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
  end

  context "successful password change" do
    before(:each) do
      google.run(command: :user_create, attributes: new_attr)
    end
    after(:each) do
      google.run(command: :user_delete, attributes: new_attr)
    end
    it "when user exists" do
      start   = google.run(command: :user_exists?, attributes: new_attr)
      expect( start[:status] ).to match('success')
      expect( start[:response].to_s ).to match('true')
      answer  = google.run(command: :user_change_password, attributes: new_attr)
      correct = new_attr[:primary_email]
      expect( answer[:status] ).to eq( 'success' )
      expect( answer[:response].primary_email ).to eq( correct )
    end
  end
  context "failing password change" do
    it "when user doesn't exist" do
      answer  = google.run(command: :user_change_password, attributes: notuser_key)
      correct = "notFound: Resource Not Found: userKey"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_change_password, attributes: bad_domain)
      correct = "forbidden: Not Authorized to access this resource/api"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
  end

  context "activate existing user" do
    before(:each) do
      google.run(command: :user_create, attributes: new_attr)
    end
    after(:each) do
      google.run(command: :user_delete, attributes: new_attr)
    end
    it "when user exists" do
      start   = google.run(command: :user_exists?, attributes: new_attr)
      expect( start[:status] ).to match('success')
      expect( start[:response].to_s ).to match('true')
      answer  = google.run(command: :user_reactivate, attributes: new_attr)
      correct = new_attr[:primary_email]
      expect( answer[:status] ).to match('success')
      expect( answer[:response].primary_email ).to eq( correct )
    end
  end
  context "failing to activate user" do
    it "when user doesn't exist" do
      answer  = google.run(command: :user_reactivate, attributes: notuser_key)
      correct = "notFound: Resource Not Found: userKey"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_reactivate, attributes: bad_domain)
      correct = "forbidden: Not Authorized to access this resource/api"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
  end

  context "suspend existing user" do
    before(:each) do
      google.run(command: :user_create, attributes: new_attr)
    end
    after(:each) do
      google.run(command: :user_delete, attributes: new_attr)
    end
    it "when user exists" do
      start   = google.run(command: :user_exists?, attributes: new_attr)
      expect( start[:status] ).to match('success')
      expect( start[:response].to_s ).to match('true')
      answer  = google.run(command: :user_suspend, attributes: new_attr)
      correct = new_attr[:primary_email]
      expect( answer[:status] ).to eq( 'success' )
      expect( answer[:response].primary_email ).to eq( correct )
    end
  end
  context "failing to suspend user" do
    it "when user doesn't exist" do
      answer  = google.run(command: :user_suspend, attributes: notuser_key)
      correct = "notFound: Resource Not Found: userKey"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_suspend, attributes: bad_domain)
      correct = "forbidden: Not Authorized to access this resource/api"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
  end

  context "delete existing user" do
    before(:each) do
      google.run(command: :user_create, attributes: new_attr)
    end
    it "when user exists" do
      start   = google.run(command: :user_exists?, attributes: new_attr)
      expect( start[:status] ).to match('success')
      expect( start[:response].to_s ).to match('true')
      answer  = google.run(command: :user_delete, attributes: new_attr)
      expect( answer[:status] ).to match('success')
      confirm = google.run(command: :user_exists?, attributes: notuser_key)
      expect( confirm[:status] ).to match('success')
      expect( confirm[:response].to_s ).to match('false')
    end
  end
  context "failing to delete user" do
    it "when user doesn't exist" do
      answer  = google.run(command: :user_delete, attributes: notuser_key)
      correct = "notFound: Resource Not Found: userKey"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
    it "with wrong domain" do
      answer  = google.run(command: :user_delete, attributes: bad_domain)
      correct = "forbidden: Not Authorized to access this resource/api"
      expect( answer[:status] ).to match('error')
      expect( answer[:response].to_s ).to eq( correct )
    end
  end

end

# errors
# "#<Google::Apis::ClientError: invalid: Invalid Password>"
# "#<Google::Apis::ClientError: duplicate: Entity already exists.>"
# "#<Google::Apis::ClientError: notFound: Resource Not Found: userKey>"
# "#<Google::Apis::ClientError: invalid: Invalid Given/Family Name: FamilyName>"
# "#<Google::Apis::ClientError: notFound: Domain not found.>"
# "#<Google::Apis::ClientError: forbidden: Not Authorized to access this resource/api>"
# #!/usr/bin/env ruby -w
#
# # SINGLE USER CHANGES
# # -------------------
#
# # create new user
# # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/AdminDirectoryV1/User
# # user_attr = {
# #   :primary_email => 'apitemp@las.ch',
# #   :name => {
# #     :given_name => 'Nicola',
# #     :family_name => 'COTTOM',
# #   },
# #   :org_unit_path => "/EMPLOYEE",
# #   :suspended => true,
# #   :password => 'n-42080-c',
# #   :change_password_at_next_login => true,
# # }
