---
id: 274
title: Install wordpress server site
date: 2019-08-22T16:01:16+01:00


guid: https://svrooij.nl/?p=274
old_permalink: /2019/08/install-wordpress-server-site/
categories:
  - Coding
tags:
  - wordpress
---
You can install wordpress by using FTP, but sometimes it's much quicker to do it server site. Basic linux knowledge is needed!. First SSH into the server.

<!--more-->

## Create a database and database user

1. Connect to mysql with `mysql -u root -p` and specify the root password. You're now in the mysql prompt (with mysql > infront).  
2. Create a database `CREATE DATABASE new_database_name;` (replace the database name off course).  
3. Create a database user `GRANT ALL PRIVILEGES ON new_database_name.* TO 'your_new_username'@'localhost' IDENTIFIED BY '_pick_a)_strong_password';`  
4. Exit mysql with CTRL+C

## Create a webfolder

Create a webfolder in any way you like. Be sure to set the permissions correctly upfront. In this post I'll assume **/home/web/domains/yourdomain.com/**

## Download and extract wordpress

You'll need to download the latest version of wordpress from wordpress.org just copy the **tar.gz** link.  
1. Go to your home folder `cd ~`  
2. Download wordpress `wget -O wordpress.tar.gz https://wordpress.org/latest.tar.gz`  
3. Extract wordpress to correct folder (replace with yours): `tar --strip-components=1 -C /home/web/domains/yourdomain.com/ -zxvf wordpress.tar.gz wordpress/`  
   This command will extract the wordpress tar.gz file (which contains a folder named wordpress) to the correct output folder.  
4. Edit the wordpress config file `nano /home/web/domains/yourdomain.com/wp-config-sample.php` set your database values and copy the secrets from [this page](https://api.wordpress.org/secret-key/1.1/salt/) (be sure to save it as wp-config.php).

## Setup NGINX (or some other webserver)

All the files needed for the wordpress installation are now ready. So you can setup the webserver. After setting up the webserver you should navigate to your website to finish the wordpress installation. Below is a basic configuration for wordpress in NGINX. The filenames are in the `####` lines. The first 3 files are snippets and can be used in multiple configurations. The first file is to make sure that no-one can download the important files if something is wrong with your php configuration.

```conf
# #################################
# /etc/nginx/snippets/wp-deny.conf
# #################################
    location = /wp-config.php {
        deny all;
    }

    location ~* /(?:uploads|files)/.*\.php$ {
        deny all;
    }
    location ~ /\.ht {
        deny all;
    }
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }

# ####################################
# /etc/nginx/snippets/fastcgi-php.conf
# ####################################

# regex to split $uri to $fastcgi_script_name and $fastcgi_path
fastcgi_split_path_info ^(.+\.php)(/.+)$;

# Check that the PHP script exists before passing it
try_files $fastcgi_script_name =404;

# Bypass the fact that try_files resets $fastcgi_path_info
# see: http://trac.nginx.org/nginx/ticket/321
set $path_info $fastcgi_path_info;
fastcgi_param PATH_INFO $path_info;

fastcgi_index index.php;
include fastcgi.conf;

# ####################################
# /etc/nginx/snippets/ssl-params.conf
# ####################################

# from https://cipherli.st/
# and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
ssl_ecdh_curve secp384r1;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
#add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
#add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
add_header Strict-Transport-Security "max-age=63072000;";
#add_header X-Frame-Options DENY;
add_header X-Frame-Options SAMEORIGIN;
add_header X-Content-Type-Options nosniff;

ssl_dhparam /etc/ssl/certs/dhparam.pem;

# ##########################################
# /etc/nginx/sites-available/yourdomain.com
# ##########################################
server {
  listen 80;
  listen &#91;::]:80;

  root /home/web/domains/yourdomain.com;

  server_name yourdomain.com;

  location /.well-known/acme-challenge/ {
    try_files $uri /dev/null =404;
  }

  location / {
    return 301 https://yourdomain.com$request_uri;
  }

}

server {
  listen 443 ssl http2;
  listen &#91;::]:443 ssl http2;

  access_log /var/log/nginx/yourdomain-access.log;
  error_log /var/log/nginx/yourdomain-error.log;

  root /home/hosting/domains/yourdomain.com;
  index index.php index.html;

  server_name yourdomain.com;
  charset UTF-8;
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem; # managed by Certbot
  include snippets/ssl-params.conf;

  add_header X-XSS-Protection "1; mode=block";
  add_header Referrer-Policy "same-origin";

  location / {
    try_files $uri $uri/ /index.php?q=$uri&$args;
  }

  location ~ \.php$ {
    client_max_body_size 25m;
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    fastcgi_read_timeout 300;
  }

  include snippets/wp-deny.conf;
}
```