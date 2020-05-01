# frozen_string_literal: true

get '/hello', to: 'hello#index'

get '/institutions', to: 'institutions#index'

post '/oauth/expats/signup', to: 'oauth/expats#signup'
post '/oauth/signin', to: 'oauth#signin'
