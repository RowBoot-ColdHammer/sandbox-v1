DOCKER := docker compose
ENV_FILE := .env

# flags
ENV := --env-file ${ENV_FILE}
FILES := --file docker-compose.main.yml

# parts
FLAGS := ${ENV} ${FILES}
IMAGES := $(shell ${DOCKER} ${FLAGS} images -q)

# volumes
VOLUMES_DIR := ./database/volumes
PGDATA_DIR := ${VOLUMES_DIR}/pgdata
MONGO_DIR := ${VOLUMES_DIR}/mongo
REDIS_DIR := ${VOLUMES_DIR}/redis

init-env: 
	@[ -f ./${ENV_FILE} ] || cp ./.env.example ./${ENV_FILE}

setup-env:
	shell grep -v '^#' _.env | xargs export

docker-up:
	${DOCKER} ${FLAGS} up -d --build
docker-down:
	${DOCKER} ${FLAGS} down
docker-rmi:
	-${DOCKER} ${FLAGS} down
	-docker rmi -f ${IMAGES}

docker-stop:
	-docker stop $(shell docker ps -a -q)
	-docker rm $(shell docker ps -a -q)
docker-clear:
	-docker stop $(shell docker ps -a -q)
	-docker rm $(shell docker ps -a -q)
	-docker rmi -f $(shell docker images -aq)
	-docker volume rm $(shell docker volume ls -q)

volumes-init:
	@[ -d $(VOLUMES_DIR) ] || mkdir -p $(VOLUMES_DIR) && sudo chown -R $(id -u):$(id -g) $(VOLUMES_DIR)
	@[ -d $(PGDATA_DIR) ] || mkdir -p $(PGDATA_DIR) && sudo chown -R $(id -u):$(id -g) $(PGDATA_DIR)
	@[ -d $(MONGO_DIR) ] || mkdir -p $(MONGO_DIR) && sudo chown -R $(id -u):$(id -g) $(MONGO_DIR)
	@[ -d $(REDIS_DIR) ] || mkdir -p $(REDIS_DIR) && sudo chown -R $(id -u):$(id -g) $(REDIS_DIR)
volumes-rm:
	- sudo rm -rf ${PGDATA_DIR}
	- sudo rm -rf ${MONGO_DIR}
	- sudo rm -rf ${REDIS_DIR}