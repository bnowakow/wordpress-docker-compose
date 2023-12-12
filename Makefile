# https://stackoverflow.com/a/35050756
# :%s/\(^\s*\)\@<=    /\t/g

DOMAIN=$(shell grep DOMAIN .env | sed -e 's/^DOMAIN=//')

start:
	docker-compose up -d

stop:
	docker-compose down

console:
	docker exec -i -t $(DOMAIN) /bin/bash

stats:
	docker stats $(DOMAIN)

logs:
	docker logs -f $(DOMAIN)

backup:
	sudo tar --exclude='config/www/gallery' -czvf backups/config-without-photos-`date +%Y-%m-%d_%H-%M`.tar.gz  config/;

# https://stackoverflow.com/a/49316987
upgrade:
		docker compose pull
		docker compose stop
		docker compose up -d --force-recreate

