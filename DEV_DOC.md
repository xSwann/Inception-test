# DEV_DOC

## Environment Setup
Prerequisites:
- Docker Engine + Docker Compose plugin
- Linux VM recommended by subject

Configuration:
1. Create env file:
```sh
cp srcs/.env.example srcs/.env
```
2. Edit `srcs/.env`:
- `DOMAIN_NAME=<login>.42.fr`
- `DATA_PATH=/home/<login>/data`
- Set database and WordPress credentials.

3. Ensure local domain resolution points to your VM IP.

## Build and Launch
Build and run:
```sh
make up
```

Stop:
```sh
make down
```

Rebuild clean:
```sh
make re
```

## Container and Volume Management Commands
Status:
```sh
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
```

Logs:
```sh
make logs
```

Remove containers/images:
```sh
make clean
```

Full cleanup (including volumes):
```sh
make fclean
```

## Persistent Data Layout
Named volumes:
- `mariadb` -> MariaDB data
- `wordpress` -> WordPress files

Host storage path (from `DATA_PATH`):
- `${DATA_PATH}/mariadb`
- `${DATA_PATH}/wordpress`

These directories persist data across container recreation.
