#!/usr/bin/env bash

php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if Composer is installed
composer -v > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

# True, if composer is not installed
if [[ $COMPOSER_IS_INSTALLED -ne 0 ]]; then
    echo ">>> Installing Composer"
    
    # Install Composer
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    
else
    echo ">>> Updating Composer"

    composer self-update
fi

sudo rm -rf /home/vagrant/ssl
mkdir /home/vagrant/ssl
cd /home/vagrant/ssl 
#>>>>>>> ordering-storeselection
openssl genrsa -out devtest.dev.key 2048
openssl req -new -x509 -key devtest.dev.key -out devtest.dev.cert -days 3650 -subj /CN=devtest.dev
sudo ln -s /vagrant /home/vagrant/laravel
sudo touch /etc/php/7.0/fpm/conf.d/01-config.ini


cat > /etc/nginx/sites-available/devtest.dev <<-"ENDICAPPCONF"
server {

    listen          80;
    server_name     devtest.dev *.devtest.dev;
    listen      443 ssl;
    ssl on;
    ssl_certificate /home/vagrant/ssl/devtest.dev.cert;
    ssl_certificate_key /home/vagrant/ssl/devtest.dev.key;

    # access_log      /var/log/nginx/cookies.access.log;
    error_log        /var/log/nginx/cookies.error.log;
    rewrite_log     on;

    root            /vagrant/public;
    index           index.php index.html;
    client_max_body_size 50M;
    # Added cache headers for images, quick fix for cloudfront.

    location ~* \.(png|jpg|jpeg|gif)$ {

    	expires 30d;
    	log_not_found off;

 	}

    # Only 3 hours on CSS/JS to allow me to roll out fixes during
    # early weeks.

    location ~* \.(js|css|ico)$ {

        # expires 3h;
    	expires 1m;
        log_not_found off;

    }

    # Heres my redirect, try normal URI and then our Laravel urls.

    location / {
        try_files $uri $uri/ /index.php?$query_string;

        # A bunch of perm page redirects from my old
        # site structure for SEO purposes. Not interesting.

        # include /etc/nginx/templates/redirects;

    }


    # Look below for this. I decided it was common to Laravel
    # sites so put it in an extra template.

    if (!-d $request_filename) {
        rewrite ^/(.+)/$ /$1 permanent;
	}


	location ~* \.php$ {
        # Server PHP config.
		fastcgi_pass                    unix:/var/run/php/php7.0-fpm.sock;
	    fastcgi_index                   index.php;
	    fastcgi_split_path_info         ^(.+\.php)(.*)$;

	    # Typical vars in here, nothing interesting.

	    include                         /etc/nginx/fastcgi_params;
	    fastcgi_param                   SCRIPT_FILENAME $document_root$fastcgi_script_name;

	}

	location ~ /\.ht {

	    # Hells no, we usin nginx up in this mutha. (deny .htaccess)
	    deny all;

	}

}
ENDICAPPCONF
sudo ln -s /etc/nginx/sites-available/devtest.dev /etc/nginx/sites-enabled/devtest.dev
sudo service nginx restart
cd /vagrant 
env_file="/vagrant/.env"
if [ ! -f /vagrant/.env ]
then
    cp -a /vagrant/.env.example /vagrant/.env
fi

# if[ ! -f "$env_file" ] 
# then
#     cp -a /vagrant/.env.example /vagrant/.env
# fi
# sudo -H -u vagrant bash -c 'composer install'
gem install sass
gem install bower
# npm install
# bower install
# php /home/vagrant/laravel/artisan ic:reset
# php /home/vagrant/laravel/artisan db:seed
# gulp
ln -s /vagrant/vagrant/.bash_aliases /home/vagrant/.bash_aliases
cd /home/vagrant
# wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
# wget https://bitbucket.org/wkhtmltopdf/wkhtmltopdf/downloads/wkhtmltox-0.13.0-alpha-7b36694_linux-trusty-amd64.deb
# tar xvf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
# sudo chown root:root wkhtmltox/bin/wkhtml*
# sudo rm /usr/local/bin/wkhtmltopdf
# sudo ln -s /home/vagrant/wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf
sudo chmod 777 -R /vagrant/storage
# mysqldump -uroot -psecret homestead > /vagrant/vagrant/config/master.sql
#sudo ln -s /home/vagrant/laravel/docs/sami-docs /home/vagrant/laravel/public/docs

echo ">>> Installing Node Version Manager"

# Install NVM
#curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
git clone https://github.com/creationix/nvm.git /home/vagrant/.nvm && cd /home/vagrant/.nvm && git checkout `git describe --abbrev=0 --tags`
sudo chown vagrant:vagrant -R /home/vagrant/.nvm
echo "source /home/vagrant/.nvm/nvm.sh" >> /home/vagrant/.bashrc
source /home/vagrant/.nvm/nvm.sh

echo ">>> Installing Node.js version $NODEJS_VERSION"
echo "    This will also be set as the default node version"

# Install Node
nvm install node

# # Set a default node version and start using it
# # nvm alias default "latest"

nvm use node
sudo chown -R vagrant:vagrant /home/vagrant/.nvm
rm -rf /vagrant/node_modules
rm -rf /vagrant/package-lock.json
cd /vagrant
npm install --save-dev
npm run dev

