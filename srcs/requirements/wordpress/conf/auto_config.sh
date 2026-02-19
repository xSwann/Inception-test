#!/bin/sh
set -e

mkdir -p /run/php

while ! mysqladmin ping -hmariadb -u"${SQL_USER}" -p"${SQL_PASSWORD}" --silent; do
	sleep 1
done

if [ ! -f /var/www/wordpress/wp-config.php ]; then
	wp config create --allow-root \
		--dbname="${SQL_DATABASE}" \
		--dbuser="${SQL_USER}" \
		--dbpass="${SQL_PASSWORD}" \
		--dbhost="mariadb:3306" \
		--path="/var/www/wordpress"
fi

if ! wp core is-installed --allow-root --path="/var/www/wordpress"; then
	wp core install --allow-root \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email \
		--path="/var/www/wordpress"

	wp user create --allow-root \
		"${WP_USER}" "${WP_USER_EMAIL}" \
		--user_pass="${WP_USER_PASSWORD}" \
		--role="author" \
		--path="/var/www/wordpress"
fi

exec php-fpm7.4 -F
