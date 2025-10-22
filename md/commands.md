
# make commands by default:

- Create .env from template if missing
```sh
make init-env
```

- Load environment variables from the .env file into the shell
```sh
make setup-env
```

- Create host volume directories and set ownership
```sh
make volumes-init
```

- Build and start the stack in detached mode
```sh
make docker-up
```

- Stop and remove containers
```sh
make docker-down
```

- Stop, remove containers, and force-remove images
```sh
make docker-rmi
```

- Stop all containers and remove them
```sh
make docker-stop
```

- Stop, remove containers, networks, volumes, and images
```sh
make docker-clear
```

- Remove host volume directories
```sh
make volumes-rm
```

Notes
- Flags and environment: The Makefile uses a default environment file and docker-compose, assembled via FLAGS. If you need to modify behavior (e.g., switch to a different compose file or env file), adjust DOCKER, ENV_FILE, or FLAGS at the top.
- Safety: Some targets (like docker-clear and volumes-rm) perform destructive actions. Use them only when you intend to remove data.
- Extendability: Consider adding a dedicated help target to list commands and descriptions, or wrapping sensitive steps with confirmations.

If you want, I can tailor the exact README snippet to your repository’s branding, include badges, or add a short usage example showing a typical workflow from initialization to startup.