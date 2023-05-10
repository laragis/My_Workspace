up:
	docker compose pull
	docker compose up -d

down:
	docker compose down

ws:
	docker compose up -d workspace
	docker compose exec --user=ubuntu workspace zsh

build-ubuntu:
	docker compose --file compose-build.yml build ubuntu

build-workspace:
	docker compose --file compose-build.yml build workspace

build: build-ubuntu build-workspace


