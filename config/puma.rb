require_relative './environment'
workers 2

threads_count = 5
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV.fetch('PORT') || 2300
environment 'production'

on_worker_boot do
  Hanami.boot
end
