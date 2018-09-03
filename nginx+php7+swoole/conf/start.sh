#!/bin/sh
# 用 swoole 运行 laravel #
# Document： https://github.com/hhxsv5/laravel-s/blob/master/README-CN.md#%E8%BF%90%E8%A1%8C #
cd /data/www && /usr/local/php/bin/php artisan laravels start
/usr/local/nginx/sbin/nginx