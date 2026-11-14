# https://github.com/jenkinsci/docker-agent/
FROM jenkins/inbound-agent:latest-jdk21 as agent


LABEL maintainer="Jonas Stumph Stevnsvig <jonas@stevnsvig.com>"
# set user to root for installation of packages
USER root
ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone \
&&  dpkg-reconfigure -f noninteractive tzdata 

# update apt cache
RUN apt-get update \
&&  apt-get upgrade -qy \
&&  apt-get install -y curl wget lsb-release ca-certificates apt-transport-https gnupg2

# add php8 repo
RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
&&  sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
&&  apt-get update

# install php8 & composer
ARG PHP_VERSION=8.5
RUN apt-get install -qy rsync zip php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION} \
    php${PHP_VERSION}-mysql php${PHP_VERSION}-zip php${PHP_VERSION}-mbstring \
apache2 unzip  php-xdebug php-pear* \
&&  curl -sSLo composer-setup.php https://getcomposer.org/installer \
&&  php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&&  composer self-update  

# Cleanup old packagess
RUN apt-get -qy autoremove

USER jenkins

ENTRYPOINT ["jenkins-slave"]
