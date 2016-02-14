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
