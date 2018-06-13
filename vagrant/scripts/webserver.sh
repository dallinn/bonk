#!/usr/bin/env bash

export LANG=C.UTF-8

PHP_TIMEZONE=America/Denver
echo ">>> Installing Nginx"
yes y | sudo ufw disable
sed -i "s/user www-data;/user vagrant;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf
# Add vagrant user to www-data group
usermod -a -G www-data vagrant
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini

sudo service php7.0-fpm restart
echo ">>> Setting up PHP $PHP_VERSION"


# Set PHP FPM to listen on TCP instead of Socket

# Set PHP FPM allowed clients IP address
sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php/7.0/fpm/pool.d/www.conf

# Set run-as user for PHP7.0-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user = www-data/user = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/group = www-data/group = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf

sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" /etc/php/7.0/fpm/pool.d/www.conf

# PHP Error Reporting Config
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini

# PHP Date Timezone
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php/7.0/cli/php.ini

sudo cat > /etc/php/7.0/fpm/conf.d/01-config.ini <<-"ENDICAPPCONF"
upload_max_filesize=520M
post_max_size=200M
max_execution_time=300
max_input_time=223
ENDICAPPCONF
sudo service nginx restart
sudo service php7.0-fpm restart



