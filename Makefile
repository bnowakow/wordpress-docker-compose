DB_PASSWORD=$(shell grep DB_PASSWORD .env | sed -e 's/^DB_PASSWORD=//')
number_of_backpus_to_keep=10

start:
	docker-compose up

stop:
	docker-compose down

backup:
	ls -1t data/mysql-dumps/* | tail -n +$(number_of_backpus_to_keep) | xargs rm;
	docker exec shared-mysql /usr/bin/mysqldump -u root --password="$(DB_PASSWORD)" wordpress > data/mysql-dumps/wordpress-`date +%Y-%m-%d_%H-%M`.sql

restore:
	# TODO pick latest backup file ASK FOR CONFIRMATION BEFOREHANDS!
	# TODO FIXME pass $DB_PASSWORD from .env file
	cat data/mysql-dumps/wordpress-PICK-BACKUP.sql | docker exec -i shared-mysql /usr/bin/mysql -u root --password="$DB_PASSWORD" wordpress

stats:
	echo TODO
	docker stats pacemaker.eu.org-mysql

logs:
	echo TODO
	
