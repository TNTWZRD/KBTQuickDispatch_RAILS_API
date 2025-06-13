#!/bin/bash

# This script is used to start the server for the application

echo "================================================"
echo "Starting Backend Rails_API Server for Quick Dispatch"

rm -r /rails/tmp/*

apt update

bundle install
rails db:migrate


rails s
