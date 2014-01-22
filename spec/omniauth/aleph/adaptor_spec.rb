require 'spec_helper'
describe "OmniAuth::Aleph::Adaptor" do
  context 'when the configuration is missing :scheme' do
    let(:config) do
      { host: 'aleph.library.edu', port: 80, library: 'ADM50', sub_library: 'SUB' }
    end

    describe '.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe '.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration is missing :host' do
    let(:config) do
      { scheme: 'http', port: 80, library: 'ADM50', sub_library: 'SUB' }
    end

    describe '.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe '.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration is missing :port' do
    let(:config) do
      { scheme: 'http', host: 'aleph.library.edu', library: 'ADM50', sub_library: 'SUB' }
    end

    describe '.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe '.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration is missing :library' do
    let(:config) do
      { scheme: 'http', host: 'aleph.library.edu', port: 80, sub_library: 'SUB' }
    end

    describe '.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe '.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration is missing :sub_library' do
    let(:config) do
      { scheme: 'http', host: 'aleph.library.edu', port: 80, library: 'ADM50' }
    end

    describe '.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe '.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration has all required fields' do
    let(:config) do
      { scheme: 'http', host: aleph_host, 
        port: 80, library: aleph_library,
        sub_library: aleph_sub_library }
    end

    subject(:adaptor) { OmniAuth::Aleph::Adaptor.new(config) }

    describe '.validate' do
      it "doesn't raise an error" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.not_to raise_error
      end
    end

    context 'when the username and password are correct' do
      describe '#authenticate', vcr: { cassette_name: "valid" } do
        it "doesn't raise an error" do
          expect{ adaptor.authenticate(aleph_username, aleph_password) }.not_to raise_error
        end

        let(:user_info) { adaptor.authenticate(aleph_username, aleph_password) }
        it "returns a hash" do
          expect(user_info).to be_a(Hash)
        end
        
        it "returns 'USERNAME' as the username" do
          expect(user_info["bor_auth"]["z303"]["z303_id"]).to eql("USERNAME")
        end
        
        it "returns 'username@library.nyu.edu' as the email" do
          expect(user_info["bor_auth"]["z304"]["z304_email_address"]).to eql("username@library.edu")
        end
        
        it "returns 'USERNAME, TEST-RECORD' as the name" do
          expect(user_info["bor_auth"]["z303"]["z303_name"]).to eql("USERNAME, TEST-RECORD")
        end
      end
    end

    context 'when the password is invalid' do
      describe '#authenticate', vcr: { cassette_name: "invalid password" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate(aleph_username, "INVALID") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end
    end

    context 'when the password is nil' do
      describe '#authenticate', vcr: { cassette_name: "nil password" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate(aleph_username, nil) }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end
    end

    context 'when the password is empty' do
      describe '#authenticate', vcr: { cassette_name: "empty password" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate(aleph_username, "") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end
    end

    context 'when the user is does not exist' do
      describe '#authenticate', vcr: { cassette_name: "nonexistent user" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate("NONEXISTENTUSER", "NONEXISTENTPASSWORD") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end
    end
  end

  context 'when the aleph host doesn\'t connect' do
    let(:config) do
      { scheme: 'http', host: "aleph.library.edu", 
        port: 80, library: "ADM50",
        sub_library: "SUB" }
    end

    subject(:adaptor) { OmniAuth::Aleph::Adaptor.new(config) }

    describe '#authenticate', :vcr do
      it "raises an Aleph error" do
        expect{ adaptor.authenticate("USERNAME", "PASSWORD") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
      end
    end
  end

  context 'when the aleph host is not actually Aleph' do
    let(:config) do
      { scheme: 'http', host: "example.com", 
        port: 80, library: "ADM50",
        sub_library: "SUB" }
    end

    subject(:adaptor) { OmniAuth::Aleph::Adaptor.new(config) }

    describe '#authenticate' do
      context 'when the host returns HTML', vcr: { cassette_name: "aleph host returns html" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate("USERNAME", "PASSWORD") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end

      context 'when the host returns an empty body', vcr: { cassette_name: "aleph host returns an empty body" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate("USERNAME", "PASSWORD") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end

      context 'when the host returns with status not found', vcr: { cassette_name: "aleph host returns with status not found" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate("USERNAME", "PASSWORD") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end

      context 'when the host returns non bor auth xml', vcr: { cassette_name: "aleph host returns non bor auth xml" } do
        it "raises an Aleph error" do
          expect{ adaptor.authenticate("USERNAME", "PASSWORD") }.to raise_error(OmniAuth::Aleph::Adaptor::AlephError)
        end
      end
    end
  end
end
