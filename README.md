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
sudo service supervisor reload
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