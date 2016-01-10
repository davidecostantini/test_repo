#!/bin/sh

##################
###Linux OS
##################

###Sys update
sudo apt-get update -y

#Installing components
sudo apt-get install puppet git -y

##################
###Folders and Scripts
##################
sudo mkdir /etc/taskize
git clone https://github.com/davidecostantini/test_repo.git /etc/taskize


##################
###Puppet
##################

###Modules
sudo puppet module install jeffmccune-motd
sudo puppet module install saz-sudo
sudo puppet module install puppetlabs-tomcat

###Puppetize
sudo puppet apply -dv /etc/taskize/init.pp


##################
###Apache
##################
apt-get install -y apache2 libapache2-mod-proxy-html libxml2-dev postgres-xc-client php5-pgsql docker-engine
a2enmod ssl
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html

mkdir /etc/apache2/ssl
cp apache2/apache.crt /etc/apache2/ssl/
cp apache2/apache.key /etc/apache2/ssl/

service apache2 restart

##################
###PostgreSQL
##################
apt-get install docker.io -y
apt-get install postgresql-client-common postgresql-client -y
PS_PWD="test1"
rm -rf /tmp/docker-library
git clone https://github.com/docker-library/postgres.git /tmp/docker-library
docker build -t "ps" /tmp/docker-library/9.5/.
docker run -dt -p 5432:5432 -e "POSTGRES_PASSWORD=$PS_PWD" ps
#This is not fully correct as would be better a for each that check when db become 
#available with a threshold of wrong attemp that trigger a failure
sleep 5  
PGPASSWORD="$PS_PWD" psql -h localhost -Upostgres < initialize_db.sql


##################
###IPtables
##################
iptables -P INPUT ACCEPT
iptables -F
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 5432 -s 127.0.0.1 -j ACCEPT
iptables -P INPUT DROP
/sbin/iptables-save
