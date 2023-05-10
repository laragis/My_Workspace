ARG UBUNTU_VERSION=latest
FROM ttungbmt/ubuntu:${UBUNTU_VERSION}

LABEL maintainer="Truong Thanh Tung <ttungbmt@gmail.com>"

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ARG USERNAME=ubuntu
ENV USER ${USERNAME}

# Start as root
USER root

# Update Package List
RUN apt-get update -y

###########################################################################
# Crontab
###########################################################################

ARG INSTALL_CRON=true

COPY ./crontab /tmp/cron.d

RUN if [ ${INSTALL_CRON} = true ]; then \
    apt-get install -y cron && \
    cp -rf /tmp/cron.d /etc/cron.d && \
    chmod -R 644 /etc/cron.d \
;fi

###########################################################################
# ssh:
###########################################################################

ARG INSTALL_SSH=true
ARG INSTALL_SSHPASS=true

COPY .ssh/insecure_id_rsa /tmp/id_rsa
COPY .ssh/insecure_id_rsa.pub /tmp/id_rsa.pub

RUN set -eux; \
    ###########################################################################
    # SSH:
    ###########################################################################
    if [ ${INSTALL_SSH} = true ]; then \
      apt-get install -y openssh-server && \
      mkdir -p /run/sshd && \
      sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
      sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
      cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys \
        && cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub \
        && cat /tmp/id_rsa >> /root/.ssh/id_rsa \
        && rm -f /tmp/id_rsa* \
        && chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub \
        && chmod 400 /root/.ssh/id_rsa \
        && cp -rf /root/.ssh /home/${USERNAME} \
        && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh \
    ;fi; \
    ###########################################################################
    # sshpass:
    ###########################################################################
    if [ ${INSTALL_SSHPASS} = true ]; then \
      apt-get install -y sshpass; \
    fi

###########################################################################
# Docker:
###########################################################################

ARG INSTALL_DOCKER=true

RUN if [ ${INSTALL_DOCKER} = true ]; then \
    curl -fsSL https://get.docker.com | bash -s && \
    # Enable user to run docker commands
    usermod -aG docker ${USERNAME} && \
    # Activate the changes to groups
    newgrp docker \
;fi

###########################################################################
# Supervisor
###########################################################################

ARG INSTALL_SUPERVISOR=true

COPY supervisord.conf /tmp/supervisord.conf
COPY supervisord.d /tmp/supervisord.d

RUN if [ ${INSTALL_SUPERVISOR} = true ]; then \
    apt-get install -y supervisor && \
    mkdir -p /etc/supervisord.d && \
    cat /tmp/supervisord.conf >> /etc/supervisord.conf && \
    if [ ${INSTALL_CRON} = true ]; then \
      cat /tmp/supervisord.d/cron.ini >> /etc/supervisord.d/cron.ini \
    ;fi && \
    if [ ${INSTALL_SSH} = true ]; then \
      cat /tmp/supervisord.d/ssh.ini >> /etc/supervisord.d/ssh.ini \
    ;fi && \
    if [ ${INSTALL_DOCKER} = true ]; then \
      cat /tmp/supervisord.d/docker.ini >> /etc/supervisord.d/docker.ini \
    ;fi \
;fi

###########################################################################
# WP CLI:
###########################################################################

# The command line interface for WordPress

USER root

ARG INSTALL_WP_CLI=true

RUN if [ ${INSTALL_WP_CLI} = true ]; then \
    curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar | bash && \
    chmod +x /usr/local/bin/wp \
;fi

###########################################################################
# DNS utilities:
###########################################################################

USER root

ARG INSTALL_DNSUTILS=false

RUN if [ ${INSTALL_DNSUTILS} = true ]; then \
    apt-get update && apt-get install -y dnsutils \
;fi

###########################################################################
# Terraform:
###########################################################################

USER root

ARG INSTALL_TERRAFORM=false
ARG TERRAFORM_VERSION=1.4.6

RUN if [ ${INSTALL_TERRAFORM} = true ]; then \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
;fi

###########################################################################
# Ansible:
###########################################################################

ARG INSTALL_ANSIBLE=true

RUN add-apt-repository -y ppa:ansible/ansible && \
    apt-get update -y && \
    if [ ${INSTALL_TERRAFORM} = true ]; then \
      apt-get install -y ansible \
    ;fi

###########################################################################
# PYTHON3:
###########################################################################

ARG INSTALL_PYTHON3=true

RUN if [ ${INSTALL_PYTHON3} = true ]; then \
  add-apt-repository -y ppa:deadsnakes/ppa && \
  apt-get update -yqq && \
  apt-get -y install \
    python3 python3-all-dev python3-dev python3-pip \
    python3-pip python3-pil python3-lxml python3-pylibmc \
    python-is-python3 \
;fi

###########################################################################
# Oh My ZSH!
###########################################################################

USER root

ARG SHELL_OH_MY_ZSH=true
ARG SHELL_OH_MY_ZSH_AUTOSUGGESTIONS=true
ARG SHELL_OH_MY_ZSH_SYNTAX_HIGHLIGHTING=true
ARG SHELL_OH_MY_ZSH_SPACESHIP_PROMPT=true
ARG SHELL_OH_MY_ZSH_ALIASES=true

RUN if [ ${SHELL_OH_MY_ZSH} = true ]; then \
    apt install -y zsh \
;fi

USER ${USERNAME}

RUN if [ ${SHELL_OH_MY_ZSH} = true ]; then \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc" && \
    echo yes | bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" && \
    echo '\n# ZSH Plugins' >> ~/.zshrc && \
    if [ ${SHELL_OH_MY_ZSH_AUTOSUGGESTIONS} = true ]; then \
      echo "zinit light zsh-users/zsh-autosuggestions" >> ~/.zshrc \
    ;fi && \
    if [ ${SHELL_OH_MY_ZSH_SYNTAX_HIGHLIGHTING} = true ]; then \
      echo "zinit light zsh-users/zsh-syntax-highlighting" >> ~/.zshrc \
    ;fi && \
    if [ ${SHELL_OH_MY_ZSH_SPACESHIP_PROMPT} = true ]; then \
      echo "zinit light spaceship-prompt/spaceship-prompt" >> ~/.zshrc \
    ;fi && \
    echo '\n# ZSH Snippet' >> ~/.zshrc && \
    if [ ${SHELL_OH_MY_ZSH_ALIASES} = true ]; then \
      echo "zinit snippet https://raw.githubusercontent.com/laragis/zsh-snippets/main/bash_aliases.sh" >> ~/.zshrc \
    ;fi \
;fi

USER root

###########################################################################
# Node / NVM:
###########################################################################

USER ${USERNAME}

# Check if NVM needs to be installed
ARG NVM_VERSION="$(lastversion nvm-sh/nvm)"
ARG NODE_VERSION=lts/*
ENV NODE_VERSION ${NODE_VERSION}
ARG INSTALL_NODE=true
ARG INSTALL_NPM_GULP=true
ARG INSTALL_NPM_BOWER=false
ARG INSTALL_NPM_VUE_CLI=false
ARG INSTALL_NPM_ANGULAR_CLI=false
ARG NPM_REGISTRY
ENV NPM_REGISTRY ${NPM_REGISTRY}
ARG NPM_FETCH_RETRIES=2
ENV NPM_FETCH_RETRIES ${NPM_FETCH_RETRIES}
ARG NPM_FETCH_RETRY_FACTOR=10
ENV NPM_FETCH_RETRY_FACTOR ${NPM_FETCH_RETRY_FACTOR}
ARG NPM_FETCH_RETRY_MINTIMEOUT=10000
ENV NPM_FETCH_RETRY_MINTIMEOUT ${NPM_FETCH_RETRY_MINTIMEOUT}
ARG NPM_FETCH_RETRY_MAXTIMEOUT=60000
ENV NPM_FETCH_RETRY_MAXTIMEOUT ${NPM_FETCH_RETRY_MAXTIMEOUT}
ENV NVM_DIR /home/${USERNAME}/.nvm

COPY --chown=${USERNAME}:${USERNAME} ./versions/node.txt /tmp/node.txt
COPY --chown=${USERNAME}:${USERNAME} ./node_packages.txt /tmp/node_packages.txt

RUN if [ ${INSTALL_NODE} = true ]; then \
    # Install nvm (A Node Version Manager)
    mkdir -p $NVM_DIR && \
    NVM_VERSION=$(eval echo $NVM_VERSION) && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
        && . $NVM_DIR/nvm.sh \
        && echo "\n$NODE_VERSION" >> /tmp/node.txt \
        && for ver in $(cat /tmp/node.txt); do \
          nvm install $ver; \
        done \
        && nvm use ${NODE_VERSION} \
        && nvm alias default ${NODE_VERSION} \
        && npm cache clear --force \
        && npm config set fetch-retries ${NPM_FETCH_RETRIES} \
        && npm config set fetch-retry-factor ${NPM_FETCH_RETRY_FACTOR} \
        && npm config set fetch-retry-mintimeout ${NPM_FETCH_RETRY_MINTIMEOUT} \
        && npm config set fetch-retry-maxtimeout ${NPM_FETCH_RETRY_MAXTIMEOUT} \
        && if [ ${NPM_REGISTRY} ]; then \
        npm config set registry ${NPM_REGISTRY} \
        ;fi \
        && echo $(grep -o '^[^#]*' /tmp/node_packages.txt | paste -sd ' ') | xargs npm install -g \
;fi

# Add NVM binaries to root's .bashrc
USER root

RUN if [ ${INSTALL_NODE} = true ]; then \
    echo "" >> ~/.bashrc && \
    echo "export NVM_DIR=\"/home/${USERNAME}/.nvm\"" >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;fi

# Mount .npmrc into home folder
COPY ./.npmrc /root/.npmrc
COPY ./.npmrc /home/${USERNAME}/.npmrc

###########################################################################
# PHP:
###########################################################################

ARG INSTALL_PHP=true

RUN if [ ${INSTALL_PHP} = true ]; then \
  add-apt-repository -y ppa:ondrej/php && \
  apt-get update -yqq && \
  apt-get install -y \
    php8.1-cli php8.1-dev \
    php8.1-pgsql php8.1-sqlite3 php8.1-gd php8.1-imagick \
    php8.1-curl \
    php8.1-imap php8.1-mysql php8.1-mbstring \
    php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap \
    php8.1-intl php8.1-readline \
    php8.1-ldap \
    php8.1-msgpack php8.1-igbinary php8.1-redis php8.1-swoole \
    php8.1-memcached php8.1-pcov php8.1-xdebug \
;fi

###########################################################################
# Composer:
###########################################################################

USER root

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php \
    && echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc \
    && mv composer.phar /usr/local/bin/composer

# Add the composer.json
COPY ./composer.json /home/${USERNAME}/.composer/composer.json

# Add the auth.json for magento 2 credentials
COPY ./auth.json /home/${USERNAME}/.composer/auth.json

# Make sure that ~/.composer belongs to Ubuntu
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.composer

# Export composer vendor path
RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

# Update composer
ARG COMPOSER_VERSION=2
ENV COMPOSER_VERSION ${COMPOSER_VERSION}
RUN set -eux; \
      if [ "$COMPOSER_VERSION" = "1" ] || [ "$COMPOSER_VERSION" = "2" ]; then \
          composer self-update --${COMPOSER_VERSION}; \
      else \
          composer self-update ${COMPOSER_VERSION}; \
      fi

USER ${USERNAME}

# Check if global install need to be ran
ARG COMPOSER_GLOBAL_INSTALL=false
ENV COMPOSER_GLOBAL_INSTALL ${COMPOSER_GLOBAL_INSTALL}

RUN if [ ${COMPOSER_GLOBAL_INSTALL} = true ]; then \
    # run the install
    composer global install \
;fi

# Check if auth file is disabled
ARG COMPOSER_AUTH_JSON=false
ENV COMPOSER_AUTH_JSON ${COMPOSER_AUTH_JSON}

RUN if [ ${COMPOSER_AUTH_JSON} = false ]; then \
    # remove the file
    rm /home/${USERNAME}/.composer/auth.json \
;fi

ARG COMPOSER_REPO_PACKAGIST
ENV COMPOSER_REPO_PACKAGIST ${COMPOSER_REPO_PACKAGIST}

RUN if [ ${COMPOSER_REPO_PACKAGIST} ]; then \
    composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST} \
;fi

# Export composer vendor path
RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc

USER root

###########################################################################
# NeoVIM:
###########################################################################
ARG INSTALL_NEOVIM=true
ARG NEOVIM_VERSION="$(lastversion neovim/neovim)"
ARG NEOVIM_CONFIG="https://github.com/NvChad/NvChad"

RUN if [ ${INSTALL_NEOVIM} = true ]; then \
    NEOVIM_VERSION=$(eval echo $NEOVIM_VERSION) && \
    curl -Lo /tmp/nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz" && \
    tar xzvf /tmp/nvim-linux64.tar.gz -C /tmp && \
    mv /tmp/nvim-linux64 /opt/nvim && \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    apt-get install -y ripgrep && \
    runuser -l ${USERNAME} -c "git clone ${NEOVIM_CONFIG} ~/.config/nvim --depth 1" \
;fi

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

USER root

WORKDIR /home/${USERNAME}

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Update Package List
RUN apt-get update -y

COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT ["start-container"]

