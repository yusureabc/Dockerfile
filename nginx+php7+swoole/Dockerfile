FROM centos:7
MAINTAINER Skiychan <dev@skiy.net>

ENV NGINX_VERSION 1.14.0
ENV PHP_VERSION 7.2.9

# 国内阿里源 #
COPY ./conf/Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo

RUN set -x && \
    yum install -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake && \

# Install PHP library
## libmcrypt-devel DIY
    rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
    yum install -y zlib \
    zlib-devel \
    openssl \
    openssl-devel \
    pcre-devel \
    libxml2 \
    libxml2-devel \
    libcurl \
    libcurl-devel \
    libpng-devel \
    libjpeg-devel \
    freetype-devel \
    libmcrypt-devel \
    openssh-server \
    python-setuptools && \

# Add user
    mkdir -p /data/{www,phpextini,phpextfile} && \
    useradd -r -s /sbin/nologin -d /data/www -m -k no www && \

# Download nginx & php
    mkdir -p /home/nginx-php && cd $_ && \
    curl -Lk http://192.168.48.128/nginx-$NGINX_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
    curl -Lk http://192.168.48.128/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \

# Make install nginx
    cd /home/nginx-php/nginx-$NGINX_VERSION && \
    ./configure --prefix=/usr/local/nginx \
    --user=www --group=www \
    --error-log-path=/var/log/nginx_error.log \
    --http-log-path=/var/log/nginx_access.log \
    --pid-path=/var/run/nginx.pid \
    --with-pcre \
    --with-http_ssl_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --with-http_gzip_static_module && \
    make && make install && \

# Make install php
    cd /home/nginx-php/php-$PHP_VERSION && \
    ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-config-file-scan-dir=/data/phpextini \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-mcrypt=/usr/include \
    --with-mysqli \
    --with-pdo-mysql \
    --with-openssl \
    --with-gd \
    --with-iconv \
    --with-zlib \
    --with-gettext \
    --with-curl \
    --with-png-dir \
    --with-jpeg-dir \
    --with-freetype-dir \
    --with-xmlrpc \
    --with-mhash \
    --enable-fpm \
    --enable-xml \
    --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \
    --enable-mbregex \
    --enable-mbstring \
    --enable-ftp \
    --enable-gd-native-ttf \
    --enable-mysqlnd \
    --enable-pcntl \
    --enable-sockets \
    --enable-zip \
    --enable-soap \
    --enable-session \
    --enable-opcache \
    --enable-bcmath \
    --enable-exif \
    --enable-fileinfo \
    --disable-rpath \
    --enable-ipv6 \
    --enable-swoole \
    --disable-debug \
    --without-pear && \
    make && make install && \

# Install Swoole
mkdir -p /home/extension && cd $_ && \
curl -Lk http://192.168.48.128/swoole-src-4.0.4.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.0.4 && \
/usr/local/php/bin/phpize && \
./configure \
--with-php-config=/usr/local/php/bin/php-config && \
make clean && make && make install && \

# Clean OS
    yum remove -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake && \
    yum clean all && \
    yum -y update && \
    rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} && \
    mkdir -p --mode=0755 /var/cache/{yum,ldconfig} && \
    find /var/log -type f -delete && \
    rm -rf /home/nginx-php && \
# timezone #
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \

# Change Mod from webdir
    chown -R www:www /data/www

# Install php-fpm
COPY ./conf/php.ini /usr/local/php/etc/php.ini
COPY ./conf/php-fpm.conf /usr/local/php/etc/php-fpm.conf
COPY ./conf/www.conf /usr/local/php/etc/php-fpm.d/www.conf

# Update nginx config
ADD ./conf/nginx.conf /usr/local/nginx/conf/
ADD ./conf/default.conf /usr/local/nginx/conf/vhost/

# Add VI config
ADD ./conf/virc /etc/virc

# Start
ADD ./conf/start.sh /
RUN chmod +x /start.sh

# Set port
EXPOSE 80 443

# Start it
# ENTRYPOINT ["/start.sh"]

# Start web server
CMD ["/bin/bash", "/start.sh"]