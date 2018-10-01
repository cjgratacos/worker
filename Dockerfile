FROM php:7.2-fpm


RUN apt-get update -y && apt-get install -y \
  wget \
  curl \
  git \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  autoconf \
  supervisor \
  libpng-dev \
  libwebp-dev \
  libjpeg62-turbo-dev \
  libxpm-dev \
  libfreetype6-dev

# Lets install iconv
RUN docker-php-ext-install -j$(nproc) iconv

# Lets configure GD
RUN docker-php-ext-configure gd \
  --with-gd \
  --with-jpeg-dir=/usr/include \
  --with-png-dir=/usr/include \
  --with-freetype-dir=/usr/include

# Lets install GD
RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml pcntl bcmath
RUN pecl channel-update pecl.php.net && pecl install memcached mcrypt-1.0.1 && docker-php-ext-enable memcached

RUN rm -rf /var/cache/apt/*

#
#--------------------------------------------------------------------------
# Optional Supervisord Configuration
#--------------------------------------------------------------------------
#
# Modify the ./supervisor.conf file to match your App's requirements.
# Make sure you rebuild your container with every change.
#

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80 9001

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]