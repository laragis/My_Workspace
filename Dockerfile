ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION} AS base

LABEL maintainer="Truong Thanh Tung <ttungbmt@gmail.com>"

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ARG USERNAME=laradock
ENV USER ${USERNAME}

# Start as root
USER root

# Update Package List
RUN apt-get update -y

# Update System Packages
RUN apt-get upgrade -y

# Mandatory Software's Installation \
RUN apt-get install -y sudo lsb-release gnupg ca-certificates apt-transport-https software-properties-common build-essential

# Install Some PPAs
RUN add-apt-repository -y ppa:ubuntugis/ppa && \
    # Git
    add-apt-repository -y ppa:git-core/ppa && \
    ## Update Package Lists
    apt-get update -y

RUN apt-get install -y \
        apt-utils make cmake dos2unix gcc gettext geoip-bin cron \
        curl wget telnet net-tools iputils-ping \
        git nano vim \
        duf htop ncdu ack-grep exa \
        zip unzip libzip-dev

###########################################################################
# Laradock non-root user:
###########################################################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

# Add group, user
RUN groupadd -g ${PGID} ${USERNAME} && \
    useradd -l -u ${PUID} -g ${PGID} -m ${USERNAME} -s /bin/bash && \
    echo "${USERNAME}:${USERNAME}" | chpasswd && \
    echo "root:root" | chpasswd

# Method 1
RUN usermod -s /bin/bash -aG sudo ${USERNAME}

## Method 2
#RUN echo "${USERNAME} ALL = NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
#    chmod 0440 /etc/sudoers.d/${USERNAME}

FROM base as workspace

#
#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# Optional Software's will only be installed if you set them to `true`
# in the `docker-compose.yml` before the build.
# Example:
#   - INSTALL_NODE=false
#   - ...
#

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=UTC
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###########################################################################
# Crontab
###########################################################################

USER root

COPY ./crontab /etc/cron.d

RUN chmod -R 644 /etc/cron.d

###########################################################################
# Docker:
###########################################################################

# Install docker-ce
RUN curl -fsSL https://get.docker.com | bash -s
#RUN install -m 0755 -d /etc/apt/keyrings && \
#    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
#    chmod a+r /etc/apt/keyrings/docker.gpg && \
#    echo \
#        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#    apt-get update -y && \
#    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

RUN curl -sS https://download.docker.com/linux/static/stable/x86_64/docker-23.0.5.tgz -o /tmp/docker.tar.gz; \
    tar -xzf /tmp/docker.tar.gz -C /tmp/; \
    cp /tmp/docker/docker* /usr/local/bin; \
    chmod +x /usr/local/bin/docker*;

## Enable vagrant user to run docker commands
#RUN groupadd docker && usermod -aG docker ${USERNAME}

############################################################################
## Composer:
############################################################################
#
#
############################################################################
## Node / NVM:
############################################################################
#
############################################################################
## PNPM:
############################################################################
#
############################################################################
## YARN:
############################################################################
#
############################################################################
## PYTHON3:
############################################################################
#
#ARG INSTALL_PYTHON3=true
#
#RUN if [ ${INSTALL_PYTHON3} = true ]; then \
#  add-apt-repository -y ppa:deadsnakes/ppa && \
#  apt-get update -yqq && \
#  apt-get -y install \
#    python3 python3-all-dev python3-dev python3-pip python-is-python3 \
#    python3-pip python3-pil python3-lxml python3-pylibmc \
#    python-is-python3 \
#;fi
#
############################################################################
## PHP:
############################################################################
#
#ARG INSTALL_PHP=true
#
#RUN if [ ${INSTALL_PHP} = true ]; then \
#  add-apt-repository -y ppa:ondrej/php && \
#  apt-get update -yqq && \
#  apt-get install -y \
#    php8.1-cli php8.1-dev \
#    php8.1-pgsql php8.1-sqlite3 php8.1-gd php8.1-imagick \
#    php8.1-curl \
#    php8.1-imap php8.1-mysql php8.1-mbstring \
#    php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap \
#    php8.1-intl php8.1-readline \
#    php8.1-ldap \
#    php8.1-msgpack php8.1-igbinary php8.1-redis php8.1-swoole \
#    php8.1-memcached php8.1-pcov php8.1-xdebug \
#;fi
#
#
############################################################################
## NEOVIM:
############################################################################
#
#USER root
#
#ARG INSTALL_NEOVIM=true
#
#RUN if [ ${INSTALL_NEOVIM} = true ]; then \
#    add-apt-repository -y ppa:neovim-ppa/stable && \
#    apt-get update -yqq && \
#    apt-get install -y neovim \
#;fi
#
############################################################################
## POWERLINE:
############################################################################
#
############################################################################
## SUPERVISOR:
############################################################################
#
############################################################################
## Terraform:
############################################################################
#
############################################################################
## Ansible:
############################################################################
#
############################################################################
## Oh My ZSH!
############################################################################
#
############################################################################
## ZSH User Aliases
############################################################################
#
#############################################################################
### DNS utilities:
#############################################################################
##
##USER root
##
##ARG INSTALL_DNSUTILS=true
##
##RUN if [ ${INSTALL_DNSUTILS} = true ]; then \
##    apt-get update && apt-get install -y dnsutils \
##;fi
#
###
###--------------------------------------------------------------------------
### Final Touch
###--------------------------------------------------------------------------
###
##
##USER root
##
### Clean up
##RUN apt-get clean && \
##    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
##    rm /var/log/lastlog /var/log/faillog
##
### Set default work directory
##WORKDIR /var/www

USER ${USERNAME}