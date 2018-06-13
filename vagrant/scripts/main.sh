#!/usr/bin/env bash

#echo "Setting Timezone & Locale to America/Denver & en_US.UTF-8"

# sudo ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
# Set the Server Timezone to EST
if [ ! -f /var/log/setup_timezone ]
then
    echo -e "--- Setting timezone ---"
    echo "America/New_York" > /etc/timezone
    sudo dpkg-reconfigure -f noninteractive tzdata

    touch /var/log/setup_timezone
fi

sudo apt-get install -qq language-pack-en language-pack-en-base
sudo locale-gen en_US
sudo update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
# Add repo for latest stable nginx
sudo add-apt-repository -y ppa:nginx/stable
# sudo add-apt-repository ppa:webupd8team/java
#sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
#sudo add-apt-repository 'deb [arch=amd64,i386] http://ftp.osuosl.org/pub/mariadb/repo/10.1/ubuntu trusty main'
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
# sudo add-apt-repository ppa:chris-lea/redis-server -y
perl -pi -e 's@^\s*(deb(\-src)?)\s+http://us.archive.*?\s+@\1 mirror://mirrors.ubuntu.com/mirrors.txt @g' /etc/apt/sources.list
#wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
#sudo apt-key add rabbitmq-signing-key-public.asc
#echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -qq curl unzip git-core ack-grep software-properties-common build-essential cachefilesd nginx php7.0-cli php7.0-fpm php7.0-mysql php7.0-sqlite php7.0-curl php7.0-gd php7.0-gmp php7.0-mcrypt php7.0-memcached php7.0-imagick php7.0-intl php7.0-mbstring php7.0-xml php7.0-bz php7.0-zip 
# redis-server clamav clamav-daemon
sudo apt-get autoremove

#setup Clamav
# sudo freshclam
# sudo chown -R vagrant:vagrant /var/log/clamav /var/lib/clamav /var/run/clamav
# sudo sed -i "s/LocalSocketGroup clamav/LocalSocketGroup vagrant/g" /etc/clamav/clamd.conf
# sudo sed -i "s/User clamav/User vagrant/g" /etc/clamav/clamd.conf
# sudo sed -i "s/DatabaseOwner clamav/DatabaseOwner vagrant/g" /etc/clamav/freshclam.conf
# sudo service clamav-daemon restart

# Redis Setup
# echo ">>> Installing Redis"
# sudo mkdir -p /etc/redis/conf.d

# transaction journaling - config is written, only enabled if persistence is requested
# cat << EOF | sudo tee /etc/redis/conf.d/journaling.conf
# appendonly yes
# appendfsync everysec
# EOF

# sudo service redis-server restart

# Setting up Swap

# Disable case sensitivity
shopt -s nocasematch

echo ">>> Setting up Swap (768 MB)"
# Create the Swap file
fallocate -l 2GB /swapfile

# Set the correct Swap permissions
chmod 600 /swapfile

# Setup Swap space
mkswap /swapfile

    # Enable Swap space
swapon /swapfile

    # Make the Swap file permanent
echo "/swapfile   none    swap    sw    0   0" | tee -a /etc/fstab

    # Add some swap settings:
    # vm.swappiness=10: Means that there wont be a Swap file until memory hits 90% useage
    # vm.vfs_cache_pressure=50: read http://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that
printf "vm.swappiness=10\nvm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf && sysctl -p



# Enable case sensitivity
shopt -u nocasematch

# Enable cachefilesd
echo "RUN=yes" > /etc/default/cachefilesd
