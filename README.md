# My_Workspace

## Setup
```shell
docker swarm init
docker network create -d overlay --attachable shared-proxy
```

Check Docker IP: `docker info`

### Steps
**Required**
- rsync, tmux, git
- Cron
- SSH
- Docker
- Supervisor

**Important**
- NodeJS, yarn, pnpm, gulp
- PHP, composer, Laravel Installer, xdebug, Deployer
- Python3, pip, virtualenv virtualenvwrapper, django, involve, poetry
- GIS: gdal

**CLI**
- WP-CLI

## SSH
```shell
ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no  -o UserKnownHostsFile=/dev/null -p 2200 -i .ssh/insecure_id_rsa ubuntu@localhost
ssh -p 2200 ubuntu@localhost
```

## Supervisor
```shell
sudo service supervisor start
sudo service supervisor status
sudo service supervisor restart
sudo service --status-all

pstree
```

## Cheatsheet
```shell
supervisorctl reread
supervisorctl update
```

## Reference
- https://github.com/becagis/BecaGIS_Workspace
- https://github.com/laravel/settler/blob/master/scripts/amd64.sh
- https://github.com/laravel/homestead/tree/main/scripts
- https://github.com/laravel/sail/tree/1.x/runtimes/8.2
- https://github.com/laradock/laradock
- https://github.com/bluxmit/alnoda-workspaces/tree/main/workspaces/ubuntu-workspace
- https://github.com/Jench2103/docker-base-workspace/blob/main/Dockerfile

## FAQs
### List groups
```shell
# List all groups a user is member of
groups
groups ubuntu

id
id ubuntu

getent group
getent group ubuntu
```

### Add user to sudo groups
```shell
# Method 1
usermod -s /bin/bash -aG sudo ${USERNAME}

# Method 2
echo "${USERNAME} ALL = NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
chmod 0440 /etc/sudoers.d/${USERNAME}
```

## Get latest version git

```shell
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
# OR
lastversion nvm-sh/nvm
```
## Download fonts

```shell
sudo apt install wget fontconfig \
&& wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip \
&& cd ~/.local/share/fonts && unzip Meslo.zip && rm *Windows* && rm Meslo.zip && fc-cache -fv
```

### Run another user

```shell
su vagrant <<'EOF'
  /usr/local/bin/composer global require "laravel/envoy=^2.0"
  /usr/local/bin/composer global require "laravel/installer=^4.2"
  /usr/local/bin/composer global config --no-plugins allow-plugins.slince/composer-registry-manager true
  /usr/local/bin/composer global require "slince/composer-registry-manager=^2.0"
EOF

runuser -l ubuntu -c 'ulimit -SHa'

```

## Best IDE
- NvChad
- AstroNvim
- LunarVim
- CosmicNvim
- VapourNvim

https://computingforgeeks.com/how-to-share-your-linux-terminal-in-web-browser-with-gotty/

# Included Software
- Ubuntu 20.04
- Git
- PHP 8.2
- PHP 8.1
- PHP 8.0
- PHP 7.4
- PHP 7.3
- PHP 7.2
- PHP 7.1
- PHP 7.0
- PHP 5.6
- ngrok
- Composer
- Nginx
- MySQL 8.0
- lmm
- Sqlite3
- PostgreSQL 15
- Docker
- Node (With Yarn, Bower, Grunt, and Gulp)
- Redis
- Memcached
- Beanstalkd
- Mailhog
- avahi
- Xdebug
- XHProf / Tideways / XHGui
- wp-cli
# Optional Software
- Apache
- Blackfire
- Cassandra
- Chronograf
- CouchDB
- Crystal & Lucky Framework
- Elasticsearch
- EventStoreDB
- Gearman
- Go
- Grafana
- InfluxDB
- MariaDB
- Meilisearch
- MinIO
- MongoDB
- Neo4j
- Oh My Zsh
- Open Resty
- PM2
- Python
- R
- RabbitMQ
- RVM (Ruby Version Manager)
- Solr
- TimescaleDB
- Trader (PHP extension)
- Webdriver & Laravel Dusk Utilities

ngrok config add-authtoken <token>

NGROK_AUTHTOKEN

```shell
ssh-keygen -t rsa -b 4096 -C "becagis.vntts@gmail.com" -f ~/.ssh/id_rsa_becagis
ssh-copy-id -i ~/.ssh/id_rsa_becagis.pub user@host
```

```shell %USERPROFILE%\.ssh\config
Host github.com
  HostName github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_github

Host becagis
  HostName 180.148.1.190
  User vntts
  Port 2200
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_becagis

Host mywaytravel
  HostName 194.233.101.85
  User discover
  Port 22
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_mywaytravel
  
Host ws
  HostName 127.0.0.1
  User ubuntu
  Port 2200
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/insecure_id_rsa
```

```shell
# Remove node modules
find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;

# Windows:
FOR /d /r . %d in (node_modules) DO @IF EXIST "%d" rm -rf "%d"

# Zip excludes folders
zip -r output.zip . -x '*.git*' -x '*node_modules*'

# Unzip
unzip filename.zip -d /path/to/directory
unzip -P PasswOrd filename.zip

unzip '*.zip'
unzip \*.zip
for z in *.zip; do unzip "$z"; done
```

```shell
docker run --rm -it \
    --name gtop \
    --net="host" \
    --pid="host" \
    aksakalli/gtop
```

- https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
- https://mosh.org/
- https://github.com/aristocratos/btop, https://github.com/aksakalli/gtop, 
- https://github.com/mgunyho/tere
- https://github.com/dylanaraps/neofetch

ZSH
- https://github.com/zsh-users/zsh-history-substring-search
- https://github.com/MichaelAquilina/zsh-you-should-use
- https://github.com/MichaelAquilina/zsh-auto-notify


```shell
# RUN pip install tldr
# RUN apt-get install -y nnn zoxide ripgrep duf htop ncdu exa rsync jq
# RUN cargo install sd choose
# https://dystroy.org/broot/download/x86_64-linux/broot
# https://github.com/dalance/procs/releases/download/v0.14.0/procs-v0.14.0-x86_64-linux.zip
# cargo install broot procs


# https://github.com/theryangeary/choose
# https://github.com/cantino/mcfly
# https://github.com/nicolargo/glances

#CMD ["tail", "-f", "/dev/null"]
#ENTRYPOINT /etc/init.d/cron start; supervisord -c "/etc/supervisord/unified-supervisord.conf"
```
```shell
if [ ${INSTALL_CRON} = true ]; then \
  cat /tmp/supervisord.d/cron.ini >> /etc/supervisord.d/cron.ini \
;fi && \
if [ ${INSTALL_SSH} = true ]; then \
  cat /tmp/supervisord.d/ssh.ini >> /etc/supervisord.d/ssh.ini \
;fi && \
if [ ${INSTALL_DOCKER} = true ]; then \
  cat /tmp/supervisord.d/docker.ini >> /etc/supervisord.d/docker.ini \
;fi && \
if [ ${INSTALL_TTYD} = true ]; then \
  cat /tmp/supervisord.d/ttyd.ini >> /etc/supervisord.d/ttyd.ini \
;fi \
```


- https://unix.stackexchange.com/questions/8656/usr-bin-vs-usr-local-bin-on-linux
```shell
/bin/ => system
/usr/bin => distribution-managed normal user programs
/usr/local/bin => not managed by the distribution package manager, e.g. locally compiled packages
```

Error not load enviroment variables
```shell
# 1
RUN /root/.cargo/bin/cargo install sd

# 2
RUN bash -c 'source "$HOME/.cargo/env && cargo install sd'

# 3
RUN ln -s /root/.cargo/bin/cargo /usr/local/bin/cargo
RUN cargo install sd

# 3
ENV PATH $PATH:/root/.cargo/bin
RUN cargo install sd

# 4
SHELL ["/bin/bash", "-l", "-c"]
RUN cargo install sd
```

```shell
# ###########################################################################
# # Rust:
# ###########################################################################

# ARG INSTALL_CARGO=true
# ENV RUSTUP_HOME=/usr/local/rustup
# ENV CARGO_HOME=/usr/local/cargo

# RUN if [ ${INSTALL_CARGO} = true ]; then \
#    curl https://sh.rustup.rs -sSf | sh -s -- -y \
# ;fi

# USER ${USERNAME}

# RUN if [ ${INSTALL_CARGO} = true ]; then \
#    mkdir -p ~/.cargo ~/.rustup && \
#    echo 'export PATH=/usr/local/cargo/bin:$PATH' >> ~/.bashrc \
#    echo 'export CARGO_HOME=~/.cargo' >> ~/.bashrc \
# ;fi

# USER root

# ###########################################################################
# # Go:
# ###########################################################################

# ARG INSTALL_GO=true
# ARG GO_VERSION="$(lastversion golang/go)"

# RUN if [ ${INSTALL_GO} = true ]; then \
#    ver=$(eval echo $GO_VERSION) && \
#    cd /tmp && wget https://golang.org/dl/go${ver}.linux-amd64.tar.gz && \
#    tar -xzf go${ver}.linux-amd64.tar.gz -C /usr/local && \
#    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc \
# ;fi

# --------------------------------------------------------------------------
# Modern basic packages
# --------------------------------------------------------------------------

RUN apt-get install -y bat httpie ripgrep duf htop ncdu exa rsync jq fzf fd-find

# RUN cargo install sd choose

# RUN bash -c 'source "$HOME/.cargo/env" && cargo install sd'
# RUN bash -c 'source /root/.bashrc && cargo install sd'
# RUN ln -s /root/.cargo/bin/cargo /usr/local/bin/cargo
# RUN cargo install sd

# RUN echo "cargo install sd" >> /tmp/temp1.sh && \
#    chmod +x /tmp/temp1.sh && \
#    bash -c /tmp/temp1.sh


# RUN ln -s $(which batcat) /usr/local/bin/bat && \
#    ln -s $(which fdfind) /usr/local/bin/fd

# ###########################################################################
# # Modern Command:
# ###########################################################################

# USER ${USERNAME}

# RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
#    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

# USER root

# RUN pip install tldr
# RUN apt-get install -y ripgrep duf htop ncdu exa rsync jq fzf

# RUN apt install -y libreadline-dev && \
#    git clone https://github.com/jarun/nnn.git /tmp/nnn && \
#    cd /tmp/nnn && make O_NERD=1 && \
#    mv /tmp/nnn /usr/bin/nnn && \
#    ln -s /usr/bin/nnn /usr/local/bin/nnn

# #RUN sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
```