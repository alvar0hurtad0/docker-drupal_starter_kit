#!/usr/bin/env bash

chown www-data:www-data /var/www/html/sites/default -R
drush config-set system.site uuid dockerdrupal-starterkit
/etc/init.d/ssh start
apachectl start
drush cim
drush cr
apachectl restart
tail -f /var/log/apache2/error.log
