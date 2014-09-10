#!/bin/sh
MYSQL_PASSWORD=password

apt-get install -y expect

mysqld_safe &
sleep 5s

MYSQL_SECURE=$(expect -c "

set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"

expect \"Change the root password?\"
send \"n\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

echo "$MYSQL_SECURE"

echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

apt-get remove -y expect
apt-get autoremove -y

killall mysqld
sleep 10s
