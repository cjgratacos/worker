FROM php:7.2-alpine


RUN apk --update add wget \
  curl \
  git \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev \
  supervisor

RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml pcntl bcmath
RUN pecl channel-update pecl.php.net && pecl install memcached mcrypt-1.0.1 && docker-php-ext-enable memcached

RUN rm /var/cache/apk/* \
    && mkdir -p /var/www

#
#--------------------------------------------------------------------------
# Optional Supervisord Configuration
#--------------------------------------------------------------------------
#
# Modify the ./supervisor.conf file to match your App's requirements.
# Make sure you rebuild your container with every change.
#

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]