#!/usr/bin/env bash

# Variables
DBNAME=homestead
DBUSER=homestead
DBPASSWD=secret

TESTDB_NAME=homestead_test
TESTDB_USER=homestead
TESTDB_PASSWD=secret

LOGDB_NAME=homestead
LOGDB_USER=homestead
LOGDB_PASSWD=secret
# DBDIRPATH=/var/lib/mysql_vagrant
DBDIRPATH=/var/lib/mysql
DBCONFIG_FILE=/vagrant/vagrant/config/mysql.cnf

#echo -e "--- Updating package list and upgrade system... --- "
# Download and Install the Latest Updates for the OS
#sudo apt-get update && sudo apt-get upgrade -y

# sudo apt-get purge -y libdbd-mysql-perl* libmariadbclient18* libmysqlclient18* mariadb-common* mysql-client-5.6* mysql-client-core-5.6* mysql-common* mysql-common-5.6* mysql-server-5.6* mysql-server-core-5.6*

# Enable Ubuntu Firewall and allow SSH & MySQL Ports
# if [ ! -f /var/log/setup_firewall ]
# then 
#     echo -e "--- Setup firewall ---"
#     yes y | sudo ufw enable
#     sudo ufw allow 22
#     sudo ufw allow 3306

#     touch /var/log/setup_firewall
# fi 

# Returns true once mysql can connect.
mysql_ready() {
    sudo mysqladmin ping --host=localhost --user=root --password=$DBPASSWD > /dev/null 2>&1
}


if [ ! -f /var/log/setup_mysql ]
then

    echo -e "--- Install MySQL specific packages and settings ---"
    export DEBIAN_FRONTEND="noninteractive"
    apt-get remove -y --purge mysql-server mysql-client mysql-common mariadb-common mysql-common
    apt-get autoremove -y
    apt-get autoclean

    rm -rf /var/lib/mysql
    rm -rf /var/log/mysql
    rm -rf /etc/mysql
    debconf-set-selections <<< "mysql-server-5.6 mysql-server/data-dir select ''"
    debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password password secret"
    debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password_again password secret"
    apt-get update
    apt-get -y install mysql-server-5.6
    echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf
    sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
    # Move initial database file to persistent directory
    # echo -e "--- Move initial database file to persistent directory ---"

    sudo service mysql stop

    # sudo chown -R mysql:mysql /var/lib/mysql
    # sudo rm -rf $DBDIRPATH/*
    # sudo cp -r -p /var/lib/mysql/* $DBDIRPATH

    # sudo mv /var/lib/mysql /var/lib/mysql.bak
    #echo "alias /var/lib/mysql/ -> $DBDIRPATH," | sudo tee -a /etc/apparmor.d/tunables/alias
    # sudo /etc/init.d/apparmor reload

    sudo cp $DBCONFIG_FILE /etc/mysql/conf.d/my_override.cnf
    sudo service mysql start

    while !(mysql_ready)
    do
       sleep 10s
       echo "---- Waiting for MySQL Connection... Check again after 10 secs..."
    done

    echo -e "--- Setting up MySQL user and db ---"
    sudo mysql -uroot -p$DBPASSWD -e "CREATE DATABASE IF NOT EXISTS $DBNAME"
    sudo mysql -uroot -p$DBPASSWD -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'%' IDENTIFIED BY '$DBPASSWD'"

    echo -e "--- Setting up TestDB ---"
    sudo mysql -uroot -p$DBPASSWD -e "CREATE DATABASE IF NOT EXISTS $TESTDB_NAME"
    sudo mysql -uroot -p$DBPASSWD -e "GRANT ALL PRIVILEGES ON $TESTDB_NAME.* TO '$TESTDB_USER'@'%' IDENTIFIED BY '$TESTDB_PASSWD'"

    echo -e "--- Setting up LogDB ---"
    sudo mysql -uroot -p$DBPASSWD -e "CREATE DATABASE IF NOT EXISTS $LOGDB_NAME"
    sudo mysql -uroot -p$DBPASSWD -e "GRANT ALL PRIVILEGES ON $LOGDB_NAME.* TO '$LOGDB_USER'@'%' IDENTIFIED BY '$LOGDB_PASSWD'"

    # Set up root user's host to be accessible from any remote
    echo -e "--- Set up root user's host to be accessible from any remote ---"
    sudo mysql -uroot -p$DBPASSWD -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'


    sudo service mysql restart

    touch /var/log/setup_mysql
else
    # If already initialized, then just restart MySQL server
    sudo service mysql start

    while !(mysql_ready)
    do
       sleep 10s
       echo "---- Waiting for MySQL Connection... Check again after 10 secs..."
    done
fi