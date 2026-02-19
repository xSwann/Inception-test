# USER_DOC

## Provided Services
- `nginx`: HTTPS entrypoint on host port `443`.
- `wordpress`: PHP-FPM application backend.
- `mariadb`: WordPress database backend.

## Start and Stop
Start:
```sh
make up
```

Stop:
```sh
make down
```

## Access Website and Admin Panel
- Website: `https://<your_login>.42.fr`
- Admin: `https://<your_login>.42.fr/wp-admin`

If certificate warning appears, accept it (self-signed cert in local setup).

## Credentials Location and Management
- Runtime variables and credentials are in local file `srcs/.env`.
- Template is `srcs/.env.example`.
- `srcs/.env` is ignored by git and must stay local.

## Health Checks
Containers:
```sh
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
```

Logs:
```sh
make logs
```

HTTPS check:
```sh
curl -k -I https://<your_login>.42.fr
```
