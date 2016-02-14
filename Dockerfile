FROM drupal:8

RUN apt-get update
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl php5-xdebug
#Set up debugger

#RUN echo "zend_extension=/usr/lib/php5/20131226/xdebug.so" >> /etc/php5/apache2/php.ini
#RUN echo "xdebug.remote_enable=1" >> /etc/php5/apache2/php.ini
#RUN echo "xdebug.remote_host=192.168.2.117" >> /etc/php5/apache2/php.ini #Please provide your host (local machine IP)

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:8.*
RUN composer global update

# Install Drupal Console.
RUN curl http://drupalconsole.com/installer -L -o drupal.phar
RUN mv drupal.phar /usr/local/bin/drupal && chmod +x /usr/local/bin/drupal
RUN drupal init

# Add important folders
ADD drupal /var/www/html
ADD data/settings.php /var/www/html/sites/default/settings.php
ADD configuration /var/www/configuration

RUN usermod -u 1000 www-data
RUN chown www-data:www-data /var/www/html/sites/default/settings.php
RUN chmod 775 /var/www/html/sites/default/settings.php
RUN chown -R www-data:www-data /var/www/html/sites/default/
RUN chown -R www-data:www-data /var/www/configuration

