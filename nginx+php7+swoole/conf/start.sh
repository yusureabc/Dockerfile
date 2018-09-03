#!/bin/sh

/usr/local/nginx/sbin/nginx
cd /data/www && /usr/local/php/bin/php artisan laravels start -d