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

