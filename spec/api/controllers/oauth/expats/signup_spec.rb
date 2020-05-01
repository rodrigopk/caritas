# frozen_string_literal: true

RSpec.describe Api::Controllers::Oauth::Expats::Signup,
               type: :unauthenticated_action do
  let(:action) { described_class.new(interactor: interactor) }
  let(:interactor) { double('Interactor') }
  subject(:response) { action.call(params) }

  describe 'given the required parameters are not present' do
    let(:params) { Hash[] }

    it 'fails' do
      expect(response[0]).to eq 422
    end

    it 'includes the parameter errors in the json response' do
      expect(response[2]).to eq([{
        errors: {
          expat: ['is missing']
        }
      }.to_json])
    end
  end

  describe 'given valid parameters' do
    let(:params) do
      {
        expat: {
          email: 'penelope@cruz.com',
          password: 'superSecretPassword',
          first_name: 'Penelope',
          last_name: 'Cruz'
        }
      }
    end

    let(:account) { double('Account') }
    let(:expat) { double('Expat') }
    let(:access_token) { 'access_token' }

    before(:each) do
      allow(interactor).to handle_signup
    end

    describe 'interactor' do
      describe 'given the interactor is successful' do
        let(:interactor_result) do
          double(
            'Interactor::Result',
            success?: true,
            account: account,
            expat: expat,
            access_token: access_token
          )
        end

        it 'returns 200 status' do
          response = action.call(params)

          expect(response[0]).to eq 200
        end

        it 'adds the created account to the context' do
          action.call(params)

          expect(action.exposures[:account]).to eq(account)
        end

        it 'adds the created expat to the context' do
          action.call(params)

          expect(action.exposures[:account]).to eq(account)
        end

        it 'adds the generated access token to the context' do
          action.call(params)

          expect(action.exposures[:access_token]).to eq(access_token)
        end
      end

      describe 'given an account for the given email exists' do
        let(:interactor_result) do
          double(
            'Interactor::Result',
            success?: false,
            errors: [Interactors::Errors.account_email_already_exists]
          )
        end

        it 'returns 409 status' do
          expect(response[0]).to eq 409
        end

        it 'includes the interactor errors in the json response' do
          expect(response[2]).to eq([{
            errors: {
              signup: [Interactors::Errors.account_email_already_exists]
            }
          }.to_json])
        end
      end

      describe 'given the interactor fails' do
        let(:interactor_result) do
          double(
            'Interactor::Result',
            success?: false,
            errors: ['interactorError']
          )
        end

        it 'returns 400 status' do
          expect(response[0]).to eq 400
        end

        it 'includes the interactor errors in the json response' do
          expect(response[2]).to eq([{
            errors: {
              signup: ['interactorError']
            }
          }.to_json])
        end
      end
    end
  end

  private

  def handle_signup
    receive(:call)
      .with(params[:expat])
      .and_return(interactor_result)
  end
end
