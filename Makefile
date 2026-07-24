# https://stackoverflow.com/a/35050756
# :%s/\(^\s*\)\@<=    /\t/g

DOMAIN=$(shell grep DOMAIN .env | sed -e 's/^DOMAIN=//')

.DEFAULT_GOAL := help

.PHONY: help codex-commit start stop restart console stats logs upgrade

help:
	@echo "Available commands"
	@echo ""
	@echo "  codex-commit  Commit staged changes with Codex, and optionally push"
	@echo "  start         Start the Docker containers"
	@echo "  stop          Stop the Docker containers"
	@echo "  restart       Restart the Docker containers"
	@echo "  console       Open a shell in the WordPress container"
	@echo "  stats         Show Docker container statistics"
	@echo "  logs          Follow WordPress container logs"
	@echo "  upgrade       Pull and recreate the Docker containers"

codex-commit:
	utilities/codex-commit.sh

start:
	docker compose up -d

stop:
	docker compose down

restart:
	docker compose restart

console:
	docker exec -i -t $(DOMAIN)-wordpress /bin/bash

stats:
	docker stats $(DOMAIN)-wordpress

logs:
	docker logs -f $(DOMAIN)-wordpress

# https://stackoverflow.com/a/49316987
upgrade:
	docker compose pull
	docker compose stop
	docker compose up -d --force-recreate
