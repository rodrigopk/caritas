# frozen_string_literal: true

RSpec.describe AccountRepository, type: :repository do
  let(:repository) { described_class.new }
  let(:expat_repository) { ExpatRepository.new }

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
      it 'returns the account' do
        account = repository.create(
          email: FFaker::Internet.email,
          password_digest: 'secretPwdDigest'
        )
        result = repository.find_by_email(account.email)

        expect(result).to eq(account)

        repository.delete(account.id)
      end
    end

    describe 'given the account has an associated expat' do
      it 'aggregates the associated expat' do
        account = repository.create(
          email: FFaker::Internet.email,
          password_digest: 'secretPwdDigest'
        )
        expat = expat_repository.create(
          account_id: account.id,
          first_name: 'Penelope',
          last_name: 'Cruz'
        )
        result = repository.find_by_email(account.email)

        expect(result.expat).to eq(expat)

        repository.delete(account.id)
      end
    end
  end
end
