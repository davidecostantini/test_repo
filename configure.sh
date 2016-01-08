#!/bin/sh

###Sys update
sudo apt-get update -y

#Installing components
sudo apt-get install puppet git -y

###Modules
sudo puppet module install jeffmccune-motd
sudo puppet module install saz-sudo
sudo puppet module install puppetlabs-tomcat

###Folders and Scripts
sudo mkdir /etc/taskize
git clone https://github.com/davidecostantini/test_repo.git /etc/taskize

###Puppetize
sudo puppet apply -dv /etc/taskize/init.pp


###Apache
apt-get install -y libapache2-mod-proxy-html libxml2-dev postgres-xc-client php5-pgsql docker-engine


###PostgreSQL
PS_PWD="test1"
rm -rf /tmp/docker-library
git clone https://github.com/docker-library/postgres.git /tmp/docker-library
docker build -t "ps" /tmp/docker-library/9.5/.
docker run -dt -p 5432:5432 -e "POSTGRES_PASSWORD=$PS_PWD" ps
sleep 5
PGPASSWORD="$PS_PWD" psql -h localhost -Upostgres < initialize_db.sql
