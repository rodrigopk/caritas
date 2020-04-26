# frozen_string_literal: true

get '/hello', to: 'hello#index'

get '/institutions', to: 'institutions#index'

get '/users/signup', to: 'users#signup'
