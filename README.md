*This project has been created as part of the 42 curriculum by slatrech*

## Description
This project builds a small Docker infrastructure for WordPress:
- `nginx` (TLS termination, only public entrypoint)
- `wordpress` (`php-fpm` only)
- `mariadb` (database only)

Goal: run isolated services in dedicated containers with persistent data and reproducible startup through `Makefile` + `docker compose`.

## Project Description
### Docker usage and included sources
The project uses:
- `srcs/docker-compose.yml`: services, network, volumes.
- `srcs/requirements/*/Dockerfile`: one Dockerfile per service.
- `srcs/requirements/*/conf` and `tools`: runtime configs and startup scripts.
- `srcs/.env` (local, ignored): environment variables and credentials.

### Main design choices
- Base image: Debian Trixie for all services.
- Runtime flow:
  - MariaDB initializes once and keeps data in a persistent volume.
  - WordPress waits for DB, then performs idempotent setup.
  - NGINX serves HTTPS and forwards PHP to `wordpress:9000`.
- Persistence uses two Docker named volumes.

### Required comparisons
#### Virtual Machines vs Docker
- VM: full OS virtualization, heavier, slower startup.
- Docker: process-level isolation, lighter, faster, easier reproducibility.

#### Secrets vs Environment Variables
- Secrets: safer for sensitive values, better for production.
- Environment variables: simple for school setup, but must not be committed.

#### Docker Network vs Host Network
- Docker bridge network: service isolation and explicit inter-service communication.
- Host network: fewer boundaries, less isolation, forbidden by subject.

#### Docker Volumes vs Bind Mounts
- Named volumes: managed lifecycle, stable persistence for containers.
- Bind mounts: direct host path mapping, more coupled to host filesystem.

## Instructions
1. Copy example env and edit values:
```sh
cp srcs/.env.example srcs/.env
```
2. Build and start:
```sh
make up
```
3. Open:
```text
https://<your_login>.42.fr
```
4. Stop:
```sh
make down
```

## Resources
- Docker docs: https://docs.docker.com/
- Compose docs: https://docs.docker.com/compose/
- NGINX docs: https://nginx.org/en/docs/
- MariaDB docs: https://mariadb.com/kb/en/documentation/
- WordPress CLI docs: https://developer.wordpress.org/cli/commands/

AI usage:
- Used for config review, shell automation, and consistency checks.
- Final service behavior and requirements compliance were manually validated and adjusted.
