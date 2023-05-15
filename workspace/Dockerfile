#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

ARG UBUNTU_VERSION=jammy-1.0.1
FROM phusion/baseimage:${UBUNTU_VERSION} as base

LABEL io.workspace.image.authors="Truong Thanh Tung <ttungbmt@gmail.com"
LABEL maintainer="Truong Thanh Tung <ttungbmt@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

ARG USERNAME="ubuntu"

# Start as root
USER root

# Update Package List
RUN apt-get update -y

# Update System Packages
RUN apt-get upgrade -y

# Mandatory Software's Installation
RUN apt-get install -y \
      sudo lsb-release \
      gnupg gosu ca-certificates apt-transport-https software-properties-common build-essential

# Install Some PPAs
RUN add-apt-repository -y ppa:ubuntugis/ppa && \
    # Git
    add-apt-repository -y ppa:git-core/ppa && \
    ## Update Package Lists
    apt-get update -y

# Install Some Basic Packages
RUN apt-get install -y \
        apt-utils make cmake dos2unix gcc gettext geoip-bin locales \
        curl wget telnet net-tools iputils-ping tmux \
        git nano vim \
        zip unzip libzip-dev

###########################################################################
# Set Locales
###########################################################################

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN locale-gen en_US.UTF-8

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=Asia/Ho_Chi_Minh
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###########################################################################
# Laradock non-root user:
###########################################################################

# Add a non-root user to prevent files being created with root permissions on host machine.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupadd -o -g ${PGID} ${USERNAME} && \
    useradd -l -u ${PUID} -g ${PGID} -m ${USERNAME} -s /bin/bash && \
    # Set password
    echo "root:root" | chpasswd && \
    echo "${USERNAME}:${USERNAME}" | chpasswd && \
    # No password input
    echo "${USERNAME} ALL = NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}


RUN mkdir -p /home/${USERNAME}/.local && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local

###########################################################################
# Supervisor
###########################################################################

ARG INSTALL_SUPERVISOR=true

COPY supervisord.conf /tmp/supervisord.conf
COPY supervisord.d /tmp/supervisord.d

RUN if [ ${INSTALL_SUPERVISOR} = true ]; then \
    apt-get install -y supervisor && \
    mkdir -p /etc/supervisord.d && \
    cat /tmp/supervisord.conf >> /etc/supervisord.conf \
;fi

###########################################################################
# PYTHON3:
###########################################################################

ARG INSTALL_PYTHON3=true

COPY ./python/requirements.txt /tmp/requirements.txt

RUN if [ ${INSTALL_PYTHON3} = true ]; then \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update -yqq && \
    apt-get -y install \
      python-is-python3 \
      python3-dev python3-pip \
      python3-psycopg2 python3-ldap \
      python3-pil python3-lxml python3-pylibmc && \
      pip install -r ./tmp/requirements.txt \
;fi

FROM base

# Fonts
#--------------------------------------------------------------------------

ARG NERDFONTS_VERSION="$(lastversion ryanoasis/nerd-fonts)"

COPY ./fonts.txt /tmp/fonts.txt

RUN apt-get install -y fontconfig && \
   ver=$(eval echo $NERDFONTS_VERSION) && \
   mkdir -p /tmp/fonts && cd /tmp/fonts && \
   for font in $(cat /tmp/fonts.txt); do \
     wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v${ver}/${font}.zip" &&\
     unzip ${font}.zip -d ./${font} &&  \
     mv ./${font}/*.ttf /usr/local/share/fonts \
   ;done && \
   fc-cache -fv

############################################################################
# gping:
###########################################################################

ARG INSTALL_GPING=true

RUN if [ ${INSTALL_GPING} = true ]; then \
   echo "deb http://packages.azlux.fr/debian/ buster main" | tee /etc/apt/sources.list.d/azlux.list && \
   wget -qO - https://azlux.fr/repo.gpg.key | apt-key add - && \
   apt-get update -y && apt-get install -y gping \
;fi

###########################################################################
# DNS utilities:
###########################################################################

ARG INSTALL_DNSUTILS=true

RUN if [ ${INSTALL_DNSUTILS} = true ]; then \
   apt-get update && apt-get install -y dnsutils \
;fi

###########################################################################
# GNU Parallel:
###########################################################################

ARG INSTALL_GNU_PARALLEL=true

RUN if [ ${INSTALL_GNU_PARALLEL} = true ]; then \
 apt-get -yqq install parallel \
;fi

###########################################################################
# GoTTY:
###########################################################################
ARG INSTALL_GOTTY=true
ARG GOTTY_VERSION="$(lastversion yudai/gotty)"

RUN if [ ${INSTALL_GOTTY} = true ]; then \
   VER=$(eval echo $GOTTY_VERSION) && \
   curl -Lo /tmp/gotty_linux_amd64.tar.gz "https://github.com/yudai/gotty/releases/download/v${VER}/gotty_linux_amd64.tar.gz" && \
   tar xvf /tmp/gotty_linux_amd64.tar.gz -C /usr/local/bin \
;fi

###########################################################################
# TTYD:
###########################################################################

ARG INSTALL_TTYD=true
ARG TTYD_VERSION="$(lastversion tsl0922/ttyd)"

RUN if [ ${INSTALL_TTYD} = true ]; then \
   TTYD_VERSION=$(eval echo $TTYD_VERSION) && \
   curl -LO https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.x86_64 && \
   mv ttyd.x86_64 /usr/bin/ttyd && \
   chmod +x /usr/bin/ttyd \
;fi

###########################################################################
# lazygit:
###########################################################################

ARG INSTALL_LAZYGIT=true
ARG LAZYGIT_VERSION="$(lastversion jesseduffield/lazygit)"

RUN if [ ${INSTALL_LAZYGIT} = true ]; then \
   LAZYGIT_VERSION=$(eval echo $LAZYGIT_VERSION) && \
   curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
   cd /tmp && tar xf lazygit.tar.gz lazygit && \
   sudo install lazygit /usr/local/bin \
;fi

###########################################################################
# Oh My ZSH!
###########################################################################

USER root

ARG SHELL_OH_MY_ZSH=true
ARG SHELL_OH_MY_ZSH_AUTOCOMPLETE=false
ARG SHELL_OH_MY_ZSH_SPACESHIP_PROMPT=true
ARG SHELL_OH_MY_ZSH_SYNTAX_HIGHLIGHTING=true
ARG SHELL_OH_MY_ZSH_AUTOSUGGESTIONS=true
ARG SHELL_OH_MY_ZSH_COMPLETIONS=true
ARG SHELL_OH_MY_ZSH_ALIASES=true
ARG ZSH_RELOAD=true


RUN if [ ${SHELL_OH_MY_ZSH} = true ]; then \
   apt install -y zsh \
;fi

RUN if [ ${SHELL_OH_MY_ZSH} = true ]; then \
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc" && \
   echo yes | bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" && \
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && \
   echo '\n# ZSH Plugins' >> ~/.zshrc && \
   if [ ${SHELL_OH_MY_ZSH_AUTOCOMPLETE} = true ]; then \
     echo "zinit light marlonrichert/zsh-autocomplete" >> ~/.zshrc \
   ;fi && \
   if [ ${SHELL_OH_MY_ZSH_SPACESHIP_PROMPT} = true ]; then \
     echo "zinit light spaceship-prompt/spaceship-prompt" >> ~/.zshrc \
   ;fi && \
   if [ ${SHELL_OH_MY_ZSH_SYNTAX_HIGHLIGHTING} = true ]; then \
     echo "zinit light zsh-users/zsh-syntax-highlighting" >> ~/.zshrc \
   ;fi && \
   if [ ${SHELL_OH_MY_ZSH_AUTOSUGGESTIONS} = true ]; then \
       echo "zinit light zsh-users/zsh-autosuggestions" >> ~/.zshrc \
   ;fi && \
   if [ ${SHELL_OH_MY_ZSH_COMPLETIONS} = true ]; then \
       echo "zinit light zsh-users/zsh-completions" >> ~/.zshrc \
   ;fi && \
   echo "zinit light MichaelAquilina/zsh-you-should-use" >> ~/.zshrc && \
   echo '\n# ZSH Snippet' >> ~/.zshrc && \
   if [ ${SHELL_OH_MY_ZSH_ALIASES} = true ]; then \
     echo "zinit snippet https://raw.githubusercontent.com/laragis/zsh-snippets/main/bash_aliases.sh" >> ~/.zshrc && \
     echo "zinit snippet https://raw.githubusercontent.com/jarun/nnn/master/misc/quitcd/quitcd.bash_sh_zsh" >> ~/.zshrc \
   ;fi && \
   if [ ${ZSH_RELOAD} = true ]; then \
      zsh -c "source ~/.zshrc" \
   ;fi \
;fi


USER root

###########################################################################
# Docker:
###########################################################################

ARG INSTALL_DOCKER=true

RUN if [ ${INSTALL_DOCKER} = true ]; then \
   curl -fsSL https://get.docker.com | bash -s && \
   # Enable user to run docker commands
   usermod -aG docker ${USERNAME} && \
   # Activate the changes to groups
   newgrp docker && \
   cat /tmp/supervisord.d/docker.ini >> /etc/supervisord.d/docker.ini \
;fi

###########################################################################
# Crontab
###########################################################################

ARG INSTALL_CRON=true

COPY ./crontab /tmp/cron.d

RUN if [ ${INSTALL_CRON} = true ]; then \
   apt-get install -y cron && \
   cp -rf /tmp/cron.d /etc/cron.d && \
   chmod -R 644 /etc/cron.d && \
   cat /tmp/supervisord.d/cron.ini >> /etc/supervisord.d/cron.ini \
;fi

###########################################################################
# Certificate Authorities
###########################################################################

COPY ./ca-certificates/* /usr/local/share/ca-certificates/
RUN update-ca-certificates

###########################################################################
# ssh:
###########################################################################

ARG INSTALL_SSH=true
ARG INSTALL_SSHPASS=true

RUN set -eux; \
   ###########################################################################
   # SSH:
   ###########################################################################
   if [ ${INSTALL_SSH} = true ]; then \
     apt-get install -y openssh-server && \
     mkdir -p /run/sshd && \
     sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
     cat /tmp/supervisord.d/ssh.ini >> /etc/supervisord.d/ssh.ini \
   ;fi; \
   ###########################################################################
   # sshpass:
   ###########################################################################
   if [ ${INSTALL_SSHPASS} = true ]; then \
     apt-get install -y sshpass; \
   fi

###########################################################################
# WP CLI:
###########################################################################

# The command line interface for WordPress

ARG INSTALL_WP_CLI=true

RUN if [ ${INSTALL_WP_CLI} = true ]; then \
   curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar | bash && \
   chmod +x /usr/local/bin/wp \
;fi

###########################################################################
# Terraform:
###########################################################################

ARG INSTALL_TERRAFORM=true
ARG TERRAFORM_VERSION="$(curl -s \"https://api.github.com/repos/hashicorp/terraform/releases/latest\" | grep -Po '\"tag_name\": \"v\K[^\"]*')"

RUN if [ ${INSTALL_TERRAFORM} = true ]; then \
   TERRAFORM_VERSION=$(eval echo $TERRAFORM_VERSION) && \
   wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
   && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
   && mv terraform /usr/local/bin \
   && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
;fi

###########################################################################
# Ansible:
###########################################################################

ARG INSTALL_ANSIBLE=true

RUN if [ ${INSTALL_ANSIBLE} = true ]; then \
   add-apt-repository -y ppa:ansible/ansible && \
   apt-get update -y && apt-get install -y ansible \
;fi

###########################################################################
# GDAl:
###########################################################################

ARG INSTALL_GDAL=true

RUN if [ ${INSTALL_GDAL} = true ]; then \
   apt-get install -y python3-gdal gdal-bin libgdal-dev && \
   pip install pygdal==$(gdal-config --version).* \
;fi


###########################################################################
# NGROX:
###########################################################################

ARG INSTALL_NGROX=true

RUN if [ ${INSTALL_NGROX} = true ]; then \
   curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
   echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && \
   apt-get update -y && apt-get install -y ngrok \
;fi

###########################################################################
# Deployer:
###########################################################################

ARG INSTALL_DEPLOYER=true

RUN if [ ${INSTALL_DEPLOYER} = true ]; then \
   # Install the Deployer
   # Using Phar as currently there is no support for laravel 4 from composer version
   # Waiting to be resolved on https://github.com/deployphp/deployer/issues/1552
   curl -LO https://deployer.org/deployer.phar && \
   mv deployer.phar /usr/local/bin/dep && \
   chmod +x /usr/local/bin/dep \
;fi

###########################################################################
# Dusk Dependencies:
###########################################################################

ARG INSTALL_DUSK_DEPS=false
ARG CHROME_DRIVER_VERSION=stable
ENV CHROME_DRIVER_VERSION ${CHROME_DRIVER_VERSION}

RUN if [ ${INSTALL_DUSK_DEPS} = true ]; then \
 apt-get -y install zip wget unzip xdg-utils \
   libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 xvfb \
   gtk2-engines-pixbuf xfonts-cyrillic xfonts-100dpi xfonts-75dpi \
   xfonts-base xfonts-scalable x11-apps \
   fonts-ipafont \
 && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
 && apt-get -y -f install \
 && dpkg -i --force-depends google-chrome-stable_current_amd64.deb \
 && rm google-chrome-stable_current_amd64.deb \
 && wget https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip \
 && unzip chromedriver_linux64.zip \
 && mv chromedriver /usr/local/bin/ \
 && rm chromedriver_linux64.zip \
;fi

###########################################################################
# Node / NVM:
###########################################################################

USER ${USERNAME}

# Check if NVM needs to be installed
ARG NVM_VERSION="$(curl -s \"https://api.github.com/repos/nvm-sh/nvm/releases/latest\" | grep -Po '\"tag_name\": \"v\K[^\"]*')"
ARG NODE_VERSION=lts/*
ENV NODE_VERSION ${NODE_VERSION}
ARG INSTALL_NODE=true
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

COPY --chown=${USERNAME}:${USERNAME} ./node/versions.txt /tmp/node_versions.txt
COPY --chown=${USERNAME}:${USERNAME} ./node/packages.txt /tmp/node_packages.txt

RUN if [ ${INSTALL_NODE} = true ]; then \
   # Install nvm (A Node Version Manager)
   mkdir -p $NVM_DIR && \
   NVM_VERSION=$(eval echo $NVM_VERSION) && \
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
       && . $NVM_DIR/nvm.sh \
       && echo "\n$NODE_VERSION" >> /tmp/node_versions.txt \
       && for ver in $(cat /tmp/node_versions.txt); do \
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

RUN if [ ${INSTALL_NODE} = true ] && [ ${SHELL_OH_MY_ZSH} = true ]; then \
   echo "" >> ~/.zshrc && \
   echo "export NVM_DIR=\"/home/${USERNAME}/.nvm\"" >> ~/.zshrc && \
   echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc \
;fi

# Add NVM binaries to root's .bashrc
USER root

RUN if [ ${INSTALL_NODE} = true ]; then \
   echo "" >> ~/.bashrc && \
   echo "export NVM_DIR=\"/home/${USERNAME}/.nvm\"" >> ~/.bashrc && \
   echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc \
;fi

# Mount .npmrc into home folder
COPY ./node/.npmrc /root/.npmrc
COPY --chown=${USERNAME}:${USERNAME} ./node/.npmrc /home/${USERNAME}/.npmrc

###########################################################################
# Git:
###########################################################################

RUN git config --global credential.helper cache

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

###########################################################################
# PHP:
###########################################################################

ARG INSTALL_PHP=true
ARG PHP_VERSION=8.1

COPY ./php/versions.txt /tmp/php_versions

RUN if [ ${INSTALL_PHP} = true ]; then \
 add-apt-repository -y ppa:ondrej/php && \
 apt-get update -yqq && \
 for ver in $(cat /tmp/php_versions); do \
   apt-get install -y --allow-change-held-packages \
   php${ver} php${ver}-bcmath php${ver}-bz2 php${ver}-cgi php${ver}-cli php${ver}-common php${ver}-curl php${ver}-dba php${ver}-dev \
   php${ver}-enchant php${ver}-fpm php${ver}-gd php${ver}-gmp php${ver}-imap php${ver}-interbase php${ver}-intl php${ver}-ldap \
   php${ver}-mbstring php${ver}-mysql php${ver}-odbc php${ver}-opcache php${ver}-pgsql php${ver}-phpdbg php${ver}-pspell php${ver}-readline \
   php${ver}-snmp php${ver}-soap php${ver}-sqlite3 php${ver}-sybase php${ver}-tidy php${ver}-xdebug php${ver}-xml php${ver}-xmlrpc php${ver}-xsl \
   php${ver}-zip php${ver}-imagick php${ver}-memcached php${ver}-redis \
 ;done \
;fi

###########################################################################
# Composer:
###########################################################################

ARG INSTALL_COMPOSER=true

RUN if [ ${INSTALL_COMPOSER} = true ] && [ ${INSTALL_PHP} = true ]; then \
   curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer && \
   composer global require "laravel/envoy=^2.0" && \
   composer global require "laravel/installer=^4.2" && \
   composer global config --no-plugins allow-plugins.slince/composer-registry-manager true && \
   composer global require "slince/composer-registry-manager=^2.0" \
;fi

# Make sure that ~/.composer belongs to USERNAME
RUN mkdir -p /home/${USERNAME}/.composer && \
   chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.composer

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

# Add the composer.json
COPY ./php/composer.json /home/${USERNAME}/.composer/composer.json

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

COPY ./php/auth.json /tmp/auth.json
RUN if [ ${COMPOSER_AUTH_JSON} = true ]; then \
   # remove the file
   cp /tmp/auth.json /home/${USERNAME}/.composer/auth.json \
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

# --------------------------------------------------------------------------
# Modern basic packages
# --------------------------------------------------------------------------

RUN apt-get install -y bat httpie ripgrep duf htop ncdu exa rsync jq fzf fd-find

USER ${USERNAME}

RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
   echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

USER root

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

USER root

COPY ./my_init.d /etc/my_init.d
RUN chmod -R +x /etc/my_init.d

WORKDIR /home/${USERNAME}

# Clean up
RUN apt-get clean && \
   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
   rm /var/log/lastlog /var/log/faillog

# Update Package List
RUN apt-get update -y

# Avoid container exit.
CMD /sbin/my_init --skip-runit --enable-insecure-key -- /usr/bin/supervisord -n -c /etc/supervisord.conf

