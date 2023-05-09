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
ARG SHELL_OH_MY_ZSH_AUTOCOMPLETE=true
ARG SHELL_OH_MY_ZSH_SYNTAX_HIGHLIGHTING=true
ARG SHELL_OH_MY_ZSH_SPACESHIP_PROMPT=true
ARG SHELL_OH_MY_ZSH_ALIASES=true

RUN if [ ${SHELL_OH_MY_ZSH} = true ]; then \
    apt install -y zsh \
;fi

USER ${USERNAME}

RUN if [ ${SHELL_OH_MY_ZSH} = true ]; then \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc" && \
    echo yes | bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" \
    echo '\n# ZSH Plugins' >> ~/.zshrc && \
    if [ ${SHELL_OH_MY_ZSH_AUTOCOMPLETE} = true ]; then \
      echo "zinit light marlonrichert/zsh-autocomplete" >> ~/.zshrc \
    ;fi && \
    if [ ${SHELL_OH_MY_ZSH_SYNTAX_HIGHLIGHTING} = true ]; then \
      echo "zinit light zsh-users/zsh-syntax-highlighting" >> ~/.zshrc \
    ;fi && \
     if [ ${SHELL_OH_MY_ZSH_SPACESHIP_PROMPT} = true ]; then \
      echo "zinit light spaceship-prompt/spaceship-prompt" >> ~/.zshrc \
    ;fi && \
    echo '\n# ZSH Snippet' >> ~/.zshrc && \
    if [ ${SHELL_OH_MY_ZSH_AUTOSUGESTIONS} = true ]; then \
      echo "zinit snippet https://raw.githubusercontent.com/laragis/zsh-snippets/main/bash_aliases.sh" >> ~/.zshrc \
    ;fi \
;fi

USER root

###########################################################################
# NeoVIM:
###########################################################################
ARG INSTALL_NEOVIM=true

RUN if [ ${INSTALL_NEOVIM} = true ]; then \
    add-apt-repository -y ppa:neovim-ppa/stable && \
    apt-get update -y && \
    apt-get install -y neovim \
    mkdir -p /home/${USERNAME}/.local/share/nvim && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local/share/nvim && \
;fi

############################################################################
## Node / NVM:
############################################################################
#
#USER ${USERNAME}
#
## Check if NVM needs to be installed
#ARG NVM_VERSION=master
#ARG NODE_VERSION=lts
#ENV NODE_VERSION ${NODE_VERSION}
#ARG INSTALL_NODE=true
#ARG INSTALL_NPM_GULP=false
#ARG INSTALL_NPM_BOWER=false
#ARG INSTALL_NPM_VUE_CLI=false
#ARG INSTALL_NPM_ANGULAR_CLI=false
#ARG NPM_REGISTRY
#ENV NPM_REGISTRY ${NPM_REGISTRY}
#ARG NPM_FETCH_RETRIES=2
#ENV NPM_FETCH_RETRIES ${NPM_FETCH_RETRIES}
#ARG NPM_FETCH_RETRY_FACTOR=10
#ENV NPM_FETCH_RETRY_FACTOR ${NPM_FETCH_RETRY_FACTOR}
#ARG NPM_FETCH_RETRY_MINTIMEOUT=10000
#ENV NPM_FETCH_RETRY_MINTIMEOUT ${NPM_FETCH_RETRY_MINTIMEOUT}
#ARG NPM_FETCH_RETRY_MAXTIMEOUT=60000
#ENV NPM_FETCH_RETRY_MAXTIMEOUT ${NPM_FETCH_RETRY_MAXTIMEOUT}
#ENV NVM_DIR /home/${USERNAME}/.nvm
#
#RUN if [ ${INSTALL_NODE} = true ]; then \
#    # Install nvm (A Node Version Manager)
#    mkdir -p $NVM_DIR && \
#    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
#    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
#        && . $NVM_DIR/nvm.sh \
#        && nvm install ${NODE_VERSION} \
#        && nvm use ${NODE_VERSION} \
#        && nvm alias ${NODE_VERSION} \
#        && npm cache clear --force \
#        && npm config set fetch-retries ${NPM_FETCH_RETRIES} \
#        && npm config set fetch-retry-factor ${NPM_FETCH_RETRY_FACTOR} \
#        && npm config set fetch-retry-mintimeout ${NPM_FETCH_RETRY_MINTIMEOUT} \
#        && npm config set fetch-retry-maxtimeout ${NPM_FETCH_RETRY_MAXTIMEOUT} \
#        && if [ ${NPM_REGISTRY} ]; then \
#        npm config set registry ${NPM_REGISTRY} \
#        ;fi \
#        && if [ ${INSTALL_NPM_GULP} = true ]; then \
#        npm install -g gulp \
#        ;fi \
#        && if [ ${INSTALL_NPM_BOWER} = true ]; then \
#        npm install -g bower \
#        ;fi \
#        && if [ ${INSTALL_NPM_VUE_CLI} = true ]; then \
#        npm install -g @vue/cli \
#        ;fi \
#        && if [ ${INSTALL_NPM_ANGULAR_CLI} = true ]; then \
#        npm install -g @angular/cli \
#        ;fi \
#;fi
#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

USER root

# Clean up
#RUN apt-get clean && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
#    rm /var/log/lastlog /var/log/faillog

# Set default work directory
RUN mkdir -p /var/www
WORKDIR /var/www

#COPY start-container /usr/local/bin/start-container
#RUN chmod +x /usr/local/bin/start-container
#
#ENTRYPOINT ["start-container"]
