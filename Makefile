# https://unix.stackexchange.com/a/471113
# :%s/^[ ]\+/\t/g

DB_PASSWORD=$(shell grep DB_PASSWORD .env | sed -e 's/^DB_PASSWORD=//')
# that would be 4 files to be kept (we've 2 db's so 2 per db)
number_of_backpus_to_keep=5

.DEFAULT_GOAL := help

.PHONY: help start stop mysql upgrade codex-commit console backup restore stats logs

help: ## Show available tasks
	@awk 'BEGIN { FS = ":.*##"; print "Available tasks:" } /^[a-zA-Z0-9_.-]+:.*##/ { printf "  %-16s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

start: ## Start the MySQL container
	docker compose up -d

stop: ## Stop the MySQL container
	docker compose stop

mysql: ## Open a MariaDB client session
	docker exec -it shared-mysql /usr/bin/mariadb -u root --password="$(DB_PASSWORD)"

upgrade: ## Pull and recreate containers, then upgrade the databases
	make backup
	docker compose pull
	docker compose stop
	docker compose up -d --force-recreate
	@attempt=0; until docker exec shared-mysql /usr/bin/mariadb-admin ping --user=root --password="$(DB_PASSWORD)" --silent; do \
		attempt=$$((attempt + 1)); \
		if [ "$$attempt" -ge 120 ]; then \
			echo "MySQL did not become ready within 120 seconds" >&2; \
			exit 1; \
		fi; \
		sleep 1; \
	done
	docker exec -it shared-mysql /usr/bin/mariadb-upgrade --user=root --password="$(DB_PASSWORD)"

codex-commit: ## Commit changes using the Codex helper
	utilities/codex-commit.sh

console: ## Open a shell in the MySQL container
	docker exec -it shared-mysql bash


number_of_backup_files=$(shell ls -1t data/mysql-dumps/* | wc -l)
backup: ## Back up the WordPress and Piwigo databases
	mkdir -p data/mysql-dumps/
	echo $(number_of_backup_files);
	if [ "$(number_of_backup_files)" -gt "$(number_of_backpus_to_keep)" ]; then\
	    ls -1t data/mysql-dumps/* | tail -n +$(number_of_backpus_to_keep) | xargs rm;\
	fi
	docker exec shared-mysql /usr/bin/mariadb-dump -u root --password="$(DB_PASSWORD)" wordpress > data/mysql-dumps/wordpress-`date +%Y-%m-%d_%H-%M`.sql
	docker exec shared-mysql /usr/bin/mariadb-dump -u root --password="$(DB_PASSWORD)" piwigo > data/mysql-dumps/piwigo-`date +%Y-%m-%d_%H-%M`.sql

restore: ## Restore the most recent database backups (currently disabled)
	# TODO ASK FOR CONFIRMATION BEFOREHANDS!
	#echo 'create database if not exists wordpress;' | docker exec -i shared-mysql /usr/bin/mariadb -u root --password="$(DB_PASSWORD)"
	#echo 'create database if not exists piwigo ;' | docker exec -i shared-mysql /usr/bin/mariadb -u root --password="$(DB_PASSWORD)"
	#cat $(shell ls -r1 data/mysql-dumps/wordpress* | head -1) | docker exec -i shared-mysql /usr/bin/mariadb -u root --password="$(DB_PASSWORD)" wordpress
	#cat $(shell ls -r1 data/mysql-dumps/piwigo* | head -1) | docker exec -i shared-mysql /usr/bin/mariadb -u root --password="$(DB_PASSWORD)" piwigo

stats: ## Show container resource usage
	docker stats shared-mysql

logs: ## Follow MySQL container logs
	docker logs -f shared-mysql
