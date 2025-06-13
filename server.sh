#/bin/bash

# This script is used to start the server for the application

bundle install
bundle exec rails db:create
bundle exec rails db:migrate

rails s
