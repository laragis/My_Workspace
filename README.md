# My_Workspace

## Setup
```shell
docker swarm init
docker network create -d overlay --attachable shared-proxy
```

### Steps
- rsync, tmux, git
- Cron
- SSH
- Docker
- Supervisor
- Python3, pip, virtualenv virtualenvwrapper, django, involve, poetry
- PHP, composer, Laravel Installer, xdebug, Deployer
- NodeJS, yarn, pnpm, gulp
- GIS: gdal

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