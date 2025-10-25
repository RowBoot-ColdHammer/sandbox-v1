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
TARANTOOL_DIR := $(VOLUMES_DIR)/tarantool

ALL_DIRS := ${PGDATA_DIR} ${MONGO_DIR} ${REDIS_DIR} ${TARANTOOL_DATA_DIR} ${TARANTOOL_DIR}


# scripts

init-env: 
	@[ -f ./${ENV_FILE} ] || cp ./.env.example ./${ENV_FILE}

setup-env:
	export $(grep -v '^#' ./${ENV_FILE} | xargs)

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
	@set -e; \
	for d in ${VOLUMES_DIR} $(ALL_DIRS); do \
		[ -z "$$d" ] && continue; \
		[ -d $$d ] || mkdir -p $$d; \
		sudo chown -R $$(id -u):$$(id -g) $$d; \
		echo "$$d - created"; \
	done

volumes-rm:
	@for d in $(ALL_DIRS) ${VOLUMES_DIR}; do \
		if [ -d $$d ]; then \
			sudo rm -rf $$d; \
			echo "$$d - removed"; \
		else \
			echo "$$d - not found, skipping"; \
		fi; \
	done