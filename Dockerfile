# from https://www.drupal.org/requirements/php#drupalversions
FROM php:7.0-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

RUN apt-get update && apt-get -y install git-all php5-curl mysql-client openssh-server wget sudo unzip vim php-apc
RUN pecl install uploadprogress
# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN wget http://files.drush.org/drush.phar \
 && chmod +x drush.phar \
 && mv drush.phar /usr/local/bin/drush

# Install drupal Console.
RUN curl https://drupalconsole.com/installer -L -o drupal.phar \
  && mv drupal.phar /usr/local/bin/drupal \
  && chmod +x /usr/local/bin/drupal \
  && composer require drupal/console

COPY web /var/www/html
COPY vendor /var/www/vendor

COPY composer.json /var/www/composer.json
COPY composer.lock /var/www/composer.lock

# Copy the settings file
COPY assets/settings.php /var/www/html/sites/default/settings.php

RUN usermod -u 1001 www-data \
    && chown www-data:www-data /var/www/html/sites/default/settings.php \
    && mkdir -p /var/www/html/sites/default/files/translations \
    && chown -R www-data:www-data /var/www/html/sites/default/

#ssh acces to allow drush alias access
RUN useradd -d /var/www drupaluser -u 1000 -G www-data -s /bin/bash
COPY assets/ssh/sshd_config /etc/ssh/sshd_config
COPY assets/ssh/sudoers /etc/sudoers
RUN mkdir -p /var/www/.ssh
COPY assets/ssh/authorized_keys /var/www/.ssh/
RUN chmod 700 /var/www/.ssh/ -R
RUN chmod 600 /var/www/.ssh/*
RUN chown drupaluser /var/www/.ssh/ -R
RUN chown drupaluser /var/www/

# Configure services
COPY assets/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
ADD assets/php/php.ini /usr/local/etc/php/conf.d/php.ini

ARG DEVELOPMENT
RUN if [ ${DEVELOPMENT} -eq 1 ] ; then \
  pecl install -o -f xdebug \
  && rm -rf /tmp/pear \
  && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_enable=on"  >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_host=172.17.42.1" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_connect_back=On" >> /usr/local/etc/php/conf.d/xdebug.ini ; \
fi

ADD rebuild.sh /root/rebuild.sh
CMD chmod +x /root/rebuild.sh && sh /root/rebuild.sh
