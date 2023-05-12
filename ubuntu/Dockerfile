ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION} AS base

LABEL maintainer="Truong Thanh Tung <ttungbmt@gmail.com>"

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ARG USERNAME=ubuntu
ENV USER ${USERNAME}

# Start as root
USER root

# Update Package List
RUN apt-get update -y

# Update System Packages
RUN apt-get upgrade -y

# Mandatory Software's Installation
RUN apt-get install -y sudo lsb-release gnupg ca-certificates apt-transport-https software-properties-common build-essential

# Install Some PPAs
RUN add-apt-repository -y ppa:ubuntugis/ppa && \
    # Git
    add-apt-repository -y ppa:git-core/ppa && \
    ## Update Package Lists
    apt-get update -y

RUN apt-get install -y \
        apt-utils make cmake dos2unix gcc gettext geoip-bin \
        curl wget telnet net-tools iputils-ping tmux \
        git nano vim \
        zip unzip libzip-dev \
        duf htop ncdu exa


###########################################################################
# Ubuntu non-root user:
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

RUN usermod -s /bin/bash -aG sudo ${USERNAME}

#
#--------------------------------------------------------------------------
# Fonts
#--------------------------------------------------------------------------
#

COPY ./fonts.txt /tmp/fonts.txt

RUN apt-get install -y fontconfig && \
    mkdir -p /home/${USERNAME}/.local/share/fonts && \
    for font in $(cat /tmp/fonts.txt); do \
      wget -P /home/${USERNAME}/.local/share/fonts $font; \
    done && \
    fc-cache -fv


###########################################################################
# bat:
###########################################################################

ARG INSTALL_BAT=true

RUN if [ ${INSTALL_BAT} = true ]; then \
    apt-get install -y bat && \
    ln -s /usr/bin/batcat /usr/local/bin/bat \
;fi

###########################################################################
# fd:
###########################################################################

ARG INSTALL_FD=true

RUN if [ ${INSTALL_FD} = true ]; then \
    apt-get install -y fd-find && \
    ln -s $(which fdfind) /usr/local/bin/fd \
;fi

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=UTC
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###########################################################################
# Python:
###########################################################################

COPY ./requirements.txt /tmp/requirements.txt

RUN apt-get install -y python-is-python3 python3-pip
RUN pip install -r ./tmp/requirements.txt

###########################################################################
# Rust:
###########################################################################

ARG INSTALL_CARGO=true

RUN if [ ${INSTALL_FD} = true ]; then \
    apt-get install -y cargo \
;fi

###########################################################################
# Go:
###########################################################################

ARG INSTALL_GO=true
ENV GOPATH="/home/${USERNAME}/go"

RUN if [ ${INSTALL_GO} = true ]; then \
    apt-get install -y golang-go && \
    echo "export GOPATH=\"$GOPATH\"" >> ~/.bashrc && \
    echo 'export GOBIN="$GOPATH/bin"' >> ~/.bashrc && \
    echo 'export PATH="$PATH:$GOBIN"' >> ~/.bashrc \
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

RUN mkdir -p /home/${USERNAME}/.local && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.local && \
    mkdir -p /home/${USERNAME}/.config && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config

WORKDIR /home/${USERNAME}

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update Package List
RUN apt-get update -y

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]