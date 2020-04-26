# frozen_string_literal: true

RSpec.describe UserRepository, type: :repository do
  let(:repository) { described_class.new }

  describe 'find_by_email' do
    it 'calls' do
      repository.find_by_email('penelope.cruz@gmail.com')
    end

    describe 'given there is no user for the given email' do
      it 'returns null' do
        result = repository.find_by_email('not_found@gmail.com')
        expect(result).to be_nil
      end
    end

    describe 'given there is an account for the given email' do
      it 'returns the user' do
        user = repository.create(
          first_name: 'Penelope',
          email: FFaker::Internet.email,
          password_digest: 'secretPwdDigest',
        )
        result = repository.find_by_email(user.email)

        expect(result).to eq(user)

        repository.delete(user.id)
      end
    end
  end
end
