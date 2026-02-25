#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

if [ ! -f /var/lib/mysql/.inception_init_done ]; then
	mysqld_safe --skip-networking &

	while ! mysqladmin ping --silent; do
		sleep 1
	done

	mysql <<-EOF
		CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
	EOF

	mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown
	touch /var/lib/mysql/.inception_init_done
	chown mysql:mysql /var/lib/mysql/.inception_init_done
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql
