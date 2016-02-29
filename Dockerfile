FROM drupal:8

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install git-all php5-curl mysql-client openssh-server
 
# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:8.* \
 && composer global update \
 && ln -s /root/.composer/vendor/bin/drush.php /usr/local/bin/drush

COPY data/settings.php /var/www/html/sites/default/settings.php

RUN usermod -u 1000 www-data \
    && chown www-data:www-data /var/www/html/sites/default/settings.php \
    && mkdir /var/www/html/sites/default/files \
    && mkdir /var/www/html/sites/default/files/translations \
    && chown -R www-data:www-data /var/www/html/sites/default/ \
    && mkdir /var/www/configuration \
    && chown -R www-data:www-data /var/www/configuration

#ssh acces to allow drush alias access
RUN useradd -d /var/www drupaluser
COPY assets/ssh/sshd_config /etc/ssh/sshd_config
RUN mkdir -p /var/www/.ssh
COPY assets/ssh/authorized_keys /var/www/.ssh