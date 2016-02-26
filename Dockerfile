FROM drupal:8

 RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install git-all php5-curl
 
# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:8.* \
 && composer global update \
 && ln -s /root/.composer/vendor/bin/drush.php /usr/local/bin/drush

COPY assets/settings.php /var/www/html/sites/default/settings.php
RUN usermod -u 1000 www-data \
    && chown www-data:www-data /var/www/html/sites/default/settings.php \
    && mkdir /var/www/html/sites/default/files \
    && mkdir /var/www/html/sites/default/files/translations \
    && chown -R www-data:www-data /var/www/html/sites/default/ \
    && mkdir /var/www/configuration \
    && chown -R www-data:www-data /var/www/configuration
