# https://stackoverflow.com/a/35050756
# :%s/\(^\s*\)\@<=    /\t/g

DOMAIN=$(shell grep DOMAIN .env | sed -e 's/^DOMAIN=//')

start:
	docker-compose up -d

stop:
	docker-compose down

restart:
	docker-compose restart

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

