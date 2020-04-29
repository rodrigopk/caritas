# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Containers::Users do
  let(:container) { described_class }

  it 'registers the user repository' do
    expect(container[:repository])
      .to be_instance_of(UserRepository)
  end

  it 'registers the interactor to handle user signup' do
    expect(container[:signup_interactor])
      .to be_instance_of(Interactors::Users::Signup)
  end

  it 'registers the interactor to handle user creation' do
    expect(container[:create_interactor])
      .to be_instance_of(Interactors::Users::Create)
  end

  it 'registers the interactor to handle user authentication' do
    expect(container[:authenticate_interactor])
      .to be_instance_of(Interactors::Users::Authenticate)
  end

  it 'registers the interactor to handle user signup' do
    expect(container[:signin_interactor])
      .to be_instance_of(Interactors::Users::Signin)
  end
end
