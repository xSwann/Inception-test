FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    php-fpm \
    php-mysql \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www \
 && cd /var/www \
 && tar -xzf wordpress-6.0-fr_FR.tar.gz \
 && rm wordpress-6.0-fr_FR.tar.gz

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp

COPY conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

CMD ["/usr/local/bin/auto_config.sh"]
