COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env
DATA_PATH_ENV := $(shell sed -n 's/^DATA_PATH=//p' srcs/.env 2>/dev/null | head -n 1)
DATA_PATH ?= /home/$(USER)/data
ifneq ($(strip $(DATA_PATH_ENV)),)
DATA_PATH := $(DATA_PATH_ENV)
endif

all: up

up: prepare
	$(COMPOSE) up -d --build

prepare:
	mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs

re: down up

clean:
	$(COMPOSE) down --rmi local --remove-orphans

fclean:
	$(COMPOSE) down --rmi local --remove-orphans --volumes

.PHONY: all up prepare down logs re clean fclean
