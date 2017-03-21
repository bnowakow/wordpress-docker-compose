# TODO read domain from .env file to get container name to do console, logs etc

start:
	docker-compose up

stop:
	docker-compose down

console:
	echo TODO
	sudo docker exec -i -t bnowakowski.pl-wordpress /bin/bash

stats:
	echo TODO
	docker stats bnowakowski.pl-wordpress

logs:
	echo TODO
	docker logs -f bnowakowski.pl-wordpress
