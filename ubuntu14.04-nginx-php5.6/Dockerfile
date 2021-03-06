FROM ubuntu:trusty

MAINTAINER Andrei Susanu <andrei.susanu@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list 
RUN sed -i "s/security.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list

# add NGINX official stable repository
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/nginx.list

# add PHP5.6 unofficial repository (https://launchpad.net/~ondrej/+archive/ubuntu/php)
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/php.list

# install packages
RUN apt-get update && \
    apt-get -y --force-yes install php5.6-geoip && \
    apt-get -y --force-yes --no-install-recommends install \
    nginx \
    vim \
    ca-certificates \
    php5.6-cli php5.6-fpm php5.6-common php5.6-mysql php5.6-mcrypt php5.6-bz2 php5.6-curl php5.6-mbstring php5.6-gd php5.6-intl php5.6-bcmath

# configure 
RUN echo "PRC" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# clear apt cache and remove unnecessary packages
RUN apt-get autoclean && apt-get -y autoremove

# PHP config
COPY ./php-fpm.conf /etc/php/5.6/fpm/php-fpm.conf
COPY ./www.conf /etc/php/5.6/fpm/pool.d/www.conf
COPY ./php.ini /etc/php/5.6/fpm/php.ini

# copy local defualt config file for NGINX
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default /etc/nginx/sites-available/default
COPY ./init.sh /

# php-fpm5.6 will not start if this directory does not exist + web directory
RUN mkdir /run/php /www

# NGINX ports
EXPOSE 80 443

CMD ["/bin/bash", "/init.sh"]
