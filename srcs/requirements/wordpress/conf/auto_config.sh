#!/bin/sh
set -e

mkdir -p /run/php

# Validate WP_ADMIN_USER doesn't contain forbidden words
if echo "${WP_ADMIN_USER}" | grep -iq "admin\|administrator"; then
	echo "ERROR: WP_ADMIN_USER cannot contain 'admin' or 'administrator'" >&2
	exit 1
fi

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

wp config set DB_NAME "${SQL_DATABASE}" --allow-root --type=constant --path="/var/www/wordpress"
wp config set DB_USER "${SQL_USER}" --allow-root --type=constant --path="/var/www/wordpress"
wp config set DB_PASSWORD "${SQL_PASSWORD}" --allow-root --type=constant --path="/var/www/wordpress"
wp config set DB_HOST "mariadb:3306" --allow-root --type=constant --path="/var/www/wordpress"

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

PHP_FPM_BIN="$(command -v php-fpm || ls /usr/sbin/php-fpm* 2>/dev/null | head -n 1)"
if [ -z "$PHP_FPM_BIN" ]; then
	echo "php-fpm binary not found" >&2
	exit 1
fi
exec "$PHP_FPM_BIN" -F
