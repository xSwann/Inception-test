#!/bin/sh
set -e

# Generate SSL certificate if it doesn't exist
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"
fi

# Substitute environment variables in nginx.conf
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf > /tmp/nginx.conf.tmp
mv /tmp/nginx.conf.tmp /etc/nginx/nginx.conf

# Start nginx in foreground mode (correct PID 1 handling)
exec nginx -g "daemon off;"
