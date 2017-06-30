require 'spec_helper'
describe "OmniAuth::Strategies::Aleph" do

  context "when it's improperly configured" do
    let(:config) {{ host: "host" }}

    subject(:strategy) do
      OmniAuth::Strategies::Aleph.new(nil, config).tap do |strategy|
        allow(strategy).to receive(:username).and_return(aleph_username)
        allow(strategy).to receive(:password).and_return(aleph_password)
      end
    end

    describe "#request_phase" do
      it 'should raise an Argument Error' do
        expect{ strategy.request_phase }.to raise_error(ArgumentError)
      end
    end

    describe "#callback_phase" do
      it 'should raise an Argument Error' do
        expect{ strategy.callback_phase }.to raise_error(ArgumentError)
      end
    end
  end

  context "when it's properly configured" do
    let(:config) do
      { host: aleph_host,
        library: aleph_library,
        sub_library: aleph_sub_library }
    end

    subject(:strategy) do
      # First argument is the app, which gets called with env,
      # i.e. app.call(env), so fake it with a stabby lambda
      OmniAuth::Strategies::Aleph.new(->(env) {}, config).tap do |strategy|
        allow(strategy).to receive(:username).and_return(aleph_username)
        allow(strategy).to receive(:password).and_return(aleph_password)
        allow(strategy).to receive(:env).and_return({})
        allow(strategy).to receive(:fail!).and_return(true)
      end
    end

    describe '#options' do
      subject(:options) { strategy.options }

      it 'should not raise an error' do
        expect { subject }.to_not raise_error
      end

      describe'#name' do
        subject { options.name }
        it { is_expected.to_not be_nil }
        it { is_expected.to eq("aleph") }
      end

      describe '#title' do
        subject { options.title }
        it { is_expected.to_not be_nil }
        it { is_expected.to eq("Aleph Authentication") }
      end

      describe '#scheme' do
        subject { options.scheme }
        it { is_expected.to_not be_nil }
        it { is_expected.to eq("http") }
      end

      describe '#host' do
        subject { options.host }
        it { is_expected.to_not be_nil }
        it { is_expected.to eq(aleph_host) }
      end

      describe '#port' do
        subject { options.port }
        it { is_expected.to_not be_nil }
        it { is_expected.to be(80) }
      end

      describe '#library' do
        subject { options.library }
        it { is_expected.to_not be_nil }
        it { is_expected.to eq(aleph_library) }
      end

      describe '#sub_library' do
        subject { options.sub_library }
        it { is_expected.to_not be_nil }
        it { is_expected.to eq(aleph_sub_library) }
      end
    end

    describe "#request_phase" do
      it 'shouldn\'t raise an error' do
        expect{ strategy.request_phase }.not_to raise_error
      end
    end

    describe "#callback_phase", vcr: { cassette_name: "valid" } do
      context "when the credentials are missing" do
        before(:each) do |example|
          allow(strategy).to receive(:username).and_return("")
          allow(strategy).to receive(:password).and_return("")
        end

        it 'shouldn\'t raise an error' do
          expect{ strategy.callback_phase }.not_to raise_error
        end

        it 'should fail!' do
          strategy.callback_phase
          expect(strategy).to have_received(:fail!)
        end
      end

      context "when the credentials are included" do
        before(:each) do
          allow(strategy).to receive(:username).and_return(aleph_username)
          allow(strategy).to receive(:password).and_return(aleph_password)
        end

        it 'shouldn\'t raise an error' do
          expect{ strategy.callback_phase }.not_to raise_error
        end

        it 'shouldn\'t fail!' do
          strategy.callback_phase
          expect(strategy).not_to have_received(:fail!)
        end
      end
    end
  end
  context "when it's used as middleware" do
    let(:config) do
      { title: "MY Aleph Authentication",
        host: aleph_host,
        library: aleph_library,
        sub_library: aleph_sub_library }
    end

    let(:app) do
      args = config
      Rack::Builder.new {
        use OmniAuth::Test::PhonySession
        use OmniAuth::Strategies::Aleph, args
        run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
      }.to_app
    end

    let(:session) do
      last_request.env['rack.session']
    end

    describe '/auth/aleph' do
      before(:each){ get '/auth/aleph' }

      it 'should display a form' do
        expect(last_response.status).to be(200)
        expect(last_response.body).to include("<form")
      end

      it 'should have the callback as the action for the form' do
        expect(last_response.body).to include("action='/auth/aleph/callback'")
      end

      it 'should have a text field for each of the fields' do
        expect(last_response.body.scan('<input').size).to be(2)
      end
      it 'should have a label of the form title' do
        expect(last_response.body.scan('MY Aleph Authentication').size).to be > 1
      end
    end

    describe 'post /auth/aleph/callback' do
      context 'failure' do
        context "when username is not present" do
          it 'should redirect to error page' do
            post('/auth/aleph/callback', {})
            expect(last_response).to be_redirect
            expect(last_response.headers['Location']).to match(%r{missing_credentials})
          end
        end

        context "when username is empty" do
          it 'should redirect to error page' do
            post('/auth/aleph/callback', {:username => ""})
            expect(last_response).to be_redirect
            expect(last_response.headers['Location']).to match(%r{missing_credentials})
          end
        end

        context "when username is present" do
          context "and password is not present" do
            it 'should redirect to error page' do
              post('/auth/aleph/callback', {:username => aleph_username})
              expect(last_response).to be_redirect
              expect(last_response.headers['Location']).to match(%r{missing_credentials})
            end
          end

          context "and password is empty" do
            it 'should redirect to error page' do
              post('/auth/aleph/callback', {:username => aleph_username, :password => ""})
              expect(last_response).to be_redirect
              expect(last_response.headers['Location']).to match(%r{missing_credentials})
            end
          end
        end

        context "when username and password are present" do
          context "and authentication failed", vcr: { cassette_name: "invalid password" } do
            it 'should redirect to error page' do
              post('/auth/aleph/callback', {:username => aleph_username, :password => 'INVALID'})
              expect(last_response).to be_redirect
              expect(last_response.headers['Location']).to match(%r{Error in Verification})
            end
          end

          context "and Aleph is down" do
            it "should redirect to error page"
          end
        end
      end

      context 'success', vcr: { cassette_name: "valid" } do
        let(:auth_hash){ last_request.env['omniauth.auth'] }

        it 'should not redirect to error page' do
          post('/auth/aleph/callback', { username: aleph_username, password: aleph_password })
          expect(last_response).not_to be_redirect
        end

        it 'should map user info to Auth Hash' do
          post('/auth/aleph/callback', { username: aleph_username, password: aleph_password })
          expect(auth_hash.uid).to eq('USERNAME')
          expect(auth_hash.info.name).to eq('USERNAME, TEST-RECORD')
          expect(auth_hash.info.nickname).to eq('USERNAME')
          expect(auth_hash.info.email).to eq('username@library.edu')
          expect(auth_hash.info.phone).to be_blank
          expect(auth_hash.extra.raw_info.bor_auth.z303.z303_id).to eq('USERNAME')
        end
      end
    end
  end
end
