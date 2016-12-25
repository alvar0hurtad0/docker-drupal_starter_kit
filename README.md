## Prerequisites

Install [Docker](https://www.docker.com/) on your system.

* [Install instructions](https://docs.docker.com/installation/mac/) for Mac OS X
* [Install instructions](https://docs.docker.com/installation/ubuntulinux/) for Ubuntu Linux
* [Install instructions](https://docs.docker.com/installation/) for other platforms

Install [Docker Compose](http://docs.docker.com/compose/) on your system.

## Setup

Put your drupal on the folder called "web". Currently only have a gitkeep file to get it on git pull of this repo.

Consider using your own composer.jso and composer.lock files.

Remove my public key from the file assets/ssh/authorized_keys and put yours. Else the only person who can access to your containers is me.

Run `docker-compose build`

## Start

Run `docker-compose up` 

After that you can enter with ssh into the running container with: docker-compose exec --user drupaluser web bash

And access to your running site on http://localhost

## Need help

I usualy help people if ask me on twitter https://twitter.com/alvar0hurtad0
