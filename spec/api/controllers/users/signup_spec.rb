# frozen_string_literal: true

RSpec.describe Api::Controllers::Users::Signup, type: :action do
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
          user: ['is missing'],
        },
      }.to_json])
    end
  end

  describe 'given valid parameters' do
    let(:params) do
      {
        user: {
          email: 'penelope@cruz.com',
          password: 'superSecretPassword',
          first_name: 'Penelope',
          last_name: 'Cruz',
        }
      }
    end

    let(:interactor_result) do
      double('Interactor::Result', success?: true, user: user)
    end
    let(:user) { double('User') }

    before(:each) do
      allow(interactor).to handle_signup
    end

    describe 'interactor' do
      it 'calls the interactor' do
        expect(interactor).to handle_signup

        action.call(params)
      end

      describe 'given the interactor is successful' do
        let(:interactor_result) do
          double('Interactor::Result', success?: true, user: user)
        end

        it 'returns 200 status' do
          response = action.call(params)

          expect(response[0]).to eq 200
        end

        it 'adds the created user to the context' do
          action.call(params)

          expect(action.exposures[:user]).to eq(user)
        end
      end

      describe 'given the interactor fails' do
        let(:interactor_result) do
          double(
            'Interactor::Result',
            success?: false,
            errors: ['interactorError'],
          )
        end

        it 'returns 400 status' do
          expect(response[0]).to eq 400
        end

        it 'includes the interactor errors in the json response' do
          expect(response[2]).to eq([{
            errors: {
              signup: ['interactorError'],
            },
          }.to_json])
        end
      end
    end
  end

  private

  def handle_signup
    receive(:call)
      .with(user_attributes: params[:user])
      .and_return(interactor_result)
  end
end
