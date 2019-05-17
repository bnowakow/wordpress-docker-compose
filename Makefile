DOMAIN=$(shell grep DOMAIN .env | sed -e 's/^DOMAIN=//')

start:
	docker-compose up -d

stop:
	docker-compose down

console:
	docker exec -i -t $(DOMAIN)-wordpress /bin/bash

stats:
	docker stats $(DOMAIN)-wordpress

logs:
	docker logs -f $(DOMAIN)-wordpress
