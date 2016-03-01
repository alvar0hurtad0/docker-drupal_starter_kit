#!/usr/bin/env bash
docker stop dockerdrupalstarterkit_web_1

docker rm dockerdrupalstarterkit_web_1
docker-compose build
docker-compose up -d
docker exec -it dockerdrupalstarterkit_web_1 /etc/init.d/ssh start
docker exec -ti dockerdrupalstarterkit_web_1 chown www-data:www-data /var/www/html/sites/default -R