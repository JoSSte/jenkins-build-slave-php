# https://github.com/jenkinsci/docker-agent/
#FROM jenkins/agent as agent
FROM jenkins/inbound-agent:latest-jdk21 as agent
#FROM jenkins/inbound-agent as agent

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
RUN apt-get install -qy rsync zip php8.5-curl php8.5-gd apache2 php8.5 unzip php8.5-mysql php8.5-zip php8.5-mbstring php-xdebug php-pear* \
&&  curl -sSLo composer-setup.php https://getcomposer.org/installer \
&&  php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
&&  composer self-update  

# Cleanup old packagess
RUN apt-get -qy autoremove

USER jenkins

ENTRYPOINT ["jenkins-slave"]
