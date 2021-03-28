NAME=$(shell grep NAME .env | sed -e 's/^NAME=//')

start:
	docker-compose up -d

stop:
	docker-compose down

console:
	docker exec -i -t $(NAME) /bin/bash

stats:
	docker stats $(NAME)

logs:
	docker-compose logs -f
