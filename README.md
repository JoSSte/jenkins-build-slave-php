# PHP docker build slave
Docker build slave for php for Jenkins

## About
php builder for running in kubernetes with jnlp


### Create

To build the image run `docker-compose build`

I prefer not having to remember a lot of parameters and so on, so there is both a [Dockerfile](Dockerfile) and a [docker-compose.yml](docker-compose.yml) the yml file is solely there to tag and name the image correctly, if you choose to just keep the image on your docker host instead of forking it and putting it in github.

## Useful tidbits

### Debugging
* `docker-compose run --rm app`
* `docker-compose run --rm -u root app`