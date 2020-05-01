# frozen_string_literal: true

get '/hello', to: 'hello#index'

get '/institutions', to: 'institutions#index'

post '/users/signup', to: 'users#signup'
post '/users/signin', to: 'users#signin'
