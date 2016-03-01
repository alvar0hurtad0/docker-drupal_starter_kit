WARNIG!!!
Currently this is a beta project for testing purposes.
It's not ready for production sites.

## Prerequisites

Install [Docker](https://www.docker.com/) on your system.

* [Install instructions](https://docs.docker.com/installation/mac/) for Mac OS X
* [Install instructions](https://docs.docker.com/installation/ubuntulinux/) for Ubuntu Linux
* [Install instructions](https://docs.docker.com/installation/) for other platforms

Install [Docker Compose](http://docs.docker.com/compose/) on your system.

## Setup

Run `docker-compose build`

## Start

Run `docker-compose up` 

open your browser and go to:
http://localhost/core/install.php

## Common issues

If you have permissions problems after rebuild you can change your permissions with docker exec.
With the containers running (you may need a second terminal) you can type something like
`docker exec -ti dockerdrupalstarterkit_web_1 chown www-data:www-data /var/www/html/sites/default -R`
