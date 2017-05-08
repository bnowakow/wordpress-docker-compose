DB_PASSWORD=$(shell grep DB_PASSWORD .env | sed -e 's/^DB_PASSWORD=//')
number_of_backpus_to_keep=10


start:
	docker-compose up -d

stop:
	docker-compose down

mysql:
	docker exec -it shared-mysql /usr/bin/mysql -u root --password="$(DB_PASSWORD)"

backup:
	mkdir -p data/mysql-dumps/
	ls -1t data/mysql-dumps/* | tail -n +$(number_of_backpus_to_keep) | xargs rm;
	docker exec shared-mysql /usr/bin/mysqldump -u root --password="$(DB_PASSWORD)" wordpress > data/mysql-dumps/wordpress-`date +%Y-%m-%d_%H-%M`.sql

restore:
	# TODO ASK FOR CONFIRMATION BEFOREHANDS!
	echo 'create database if not exists wordpress;' | docker exec -i shared-mysql /usr/bin/mysql -u root --password="$(DB_PASSWORD)"
	cat data/mysql-dumps/$(shell ls -r1 data/mysql-dumps/ | head -1) | docker exec -i shared-mysql /usr/bin/mysql -u root --password="$(DB_PASSWORD)" wordpress

stats:
	docker stats shared-mysql

logs:
	docker logs -f shared-mysql
