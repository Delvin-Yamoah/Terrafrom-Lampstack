#!/bin/bash
apt-get update
apt-get install -y mysql-server

# Configure MySQL
systemctl start mysql
systemctl enable mysql

# Set root password and create database
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'rootpass123';"
mysql -u root -prootpass123 -e "CREATE DATABASE visitcounter;"
mysql -u root -prootpass123 -e "CREATE USER 'appuser'@'%' IDENTIFIED BY 'apppass123';"
mysql -u root -prootpass123 -e "GRANT ALL PRIVILEGES ON visitcounter.* TO 'appuser'@'%';"
mysql -u root -prootpass123 -e "FLUSH PRIVILEGES;"

# Create visits table
mysql -u root -prootpass123 visitcounter -e "CREATE TABLE visits (id INT AUTO_INCREMENT PRIMARY KEY, count INT DEFAULT 0);"
mysql -u root -prootpass123 visitcounter -e "INSERT INTO visits (count) VALUES (0);"

# Configure MySQL to accept external connections
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql