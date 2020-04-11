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

