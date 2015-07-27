#!/bin/bash

rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
yum install -y mysql-community-server php php-pdo php-soap php-xml php-mysql httpd
ln -s /vagrant/website /var/www/html/
systemctl disable firewalld
service httpd restart
