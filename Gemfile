# frozen_string_literal: true

source 'https://rubygems.org'

gem 'hanami', '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'puma'
gem 'rake'

gem 'pg'

gem 'bcrypt'
gem 'jwt'
gem 'warden'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'hanami-webconsole'
  # gem 'shotgun', platforms: :ruby
  gem 'guard-rspec', require: false
end

group :test, :development do
  gem 'byebug'
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'capybara'
  gem 'ffaker'
  gem 'rspec'
  gem 'timecop'
end
