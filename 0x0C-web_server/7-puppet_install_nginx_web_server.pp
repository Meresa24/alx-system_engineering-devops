#!/usr/bin/env bash
# Installs, configures, and starts the server
apt-get update
apt-get -y install nginx
ufw allow 'Nginx HTTP'
mkdir -p /var/www/html /var/www/error
chmod -R 755 /var/www
echo 'Hello World!' > /var/www/html/index.html
echo -e "Ceci n\x27est pas une page" > /var/www/error/404.html
# the server's configuration
SERVER_CONFIG=\
"server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                try_files \$uri \$uri/ =404;
        }

        if (\$request_filename ~ redirect_me){
                rewrite ^ https://sketchfab.com/bluepeno/models permanent;
        }

        error_page 404 /404.html;
        location = /404.html {
                root /var/www/error/;
                internal;
        }
}"
bash -c "echo -e '$SERVER_CONFIG' > /etc/nginx/sites-enabled/default"
if [ "$(pgrep -c nginx)" -le 0 ]; then
        service nginx start
else
        service nginx restart
fi
