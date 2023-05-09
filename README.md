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

## Best IDE
- NvChad
- AstroNvim
- LunarVim
- CosmicNvim
- VapourNvim