dev:
	docker-compose -f ./docker/docker-compose.dev.yml up --remove-orphans

dev-update:
	docker-compose -f ./docker/docker-compose.dev.yml up --build -V  --remove-orphans

dev-scale:
	docker-compose -f ./docker/docker-compose.dev.yml up --build -V  --scale immich_server=3 --remove-orphans 
