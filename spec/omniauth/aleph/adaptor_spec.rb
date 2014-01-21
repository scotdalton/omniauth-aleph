require 'spec_helper'
describe "OmniAuth::Aleph::Adaptor" do
  context 'when the configuration is missing :host' do
    let(:config) do
      { library: 'ADM50', sub_library: 'SUB' }
    end

    describe 'self.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe 'self.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration is missing :library' do
    let(:config) do
      { host: 'aleph.library.edu', sub_library: 'SUB' }
    end

    describe 'self.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe 'self.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration is missing :sub_library' do
    let(:config) do
      { host: 'aleph.library.edu', library: 'ADM50' }
    end

    describe 'self.validate' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.to raise_error(ArgumentError)
      end
    end

    describe 'self.new' do
      it "raises an ArgumentError" do
        expect{ OmniAuth::Aleph::Adaptor.new config }.to raise_error(ArgumentError)
      end
    end
  end

  context 'when the configuration has all required fields' do
    let(:config) do
      { host: 'aleph.library.edu', library: 'ADM50', sub_library: 'SUB' }
    end

    subject(:adaptor) { OmniAuth::Aleph::Adaptor.new(config) }

    describe 'self.validate' do
      it "doesn't raise an error" do
        expect{ OmniAuth::Aleph::Adaptor.validate config }.not_to raise_error
      end
    end

  end
end
