server '52.220.134.79', user: 'kyle', roles: %w{web app db}
set :application, 'boltbutton'
set :rails_env, 'staging'
set :branch, 'master'