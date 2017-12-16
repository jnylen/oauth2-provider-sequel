#!/bin/bash
sudo locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apt-transport-https
sudo apt-get install -y curl

# PostgreSQL
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql postgresql-client postgresql-contrib libpq-dev
sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /etc/postgresql/10.*/main/postgresql.conf
sudo systemctl enable postgresql.service
sudo service postgresql restart
sudo su postgres -c "psql -c \"CREATE ROLE root SUPERUSER LOGIN PASSWORD 'oAutH2Prov'\" "
sudo su postgres -c "createdb -E UTF8 -T template0 --locale=en_US.utf8 -O root oauth2_test"

# RVM
sudo su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
sudo su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable'
sudo su - vagrant -c 'rvm install 2.4.3'
sudo su - vagrant -c 'rvm use 2.4.3 --default'
sudo su - vagrant -c 'gem install bundler'

# First run things
sudo su - vagrant -c 'cd /vagrant && bundle install'
