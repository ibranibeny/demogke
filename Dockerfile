FROM debian
  
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -q -y   && \
  apt-get install -y php-bz2 php-sqlite3 php-redis nginx php php-fpm php-cgi php-cli  && \
  apt-get install -y supervisor  php-common php-cli php-gd php-mysql php-curl php-intl php-mbstring php-bcmath php-imap php-xml php-zip && \
  apt-get install -y php-memcached php-soap php-ctype  php-zip php-simplexml  php-dom php-xml php-json php-intl php-fpm php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl libpq-dev  rsyslog  && \
  apt-get install -y msmtp php-mail net-tools curl git htop man unzip vim wget && \
  apt-get install procps -y && \
  apt-get install -q -y syslog-ng && \
  apt-get install -y --no-install-recommends --no-install-suggests   supervisor openssh-client cron

RUN mkdir -p /run/php
RUN mkdir -p /var/www/web
COPY config/php.ini /etc/php/7.4/fpm/php.ini
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/web.conf /etc/nginx/sites-enabled/default
COPY code/wordpress /var/www/web/
COPY config/docker-init.sh /var/www/web/
COPY config/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY config/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY config/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN chown www-data:www-data /var/www
RUN chown -R www-data:www-data /var/www/*
RUN chmod 755 -R /var/www/*
RUN phpenmod opcache

RUN mkdir -p /var/log/3c-api
RUN mkdir -p /run/php

WORKDIR /var/www/web

ENTRYPOINT ["/var/www/web/docker-init.sh"]