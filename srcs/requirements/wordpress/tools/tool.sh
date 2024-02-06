#!/bin/sh

# Check if wp-config.php exists
if [ -f "/var/www/wordpress/wp-config.php" ]; then
    echo "WordPress already exists"
else
    # Download WordPress using WP-CLI
    wp core download --allow-root
    echo "WordPress core downloaded"

    # Configure WordPress database
    wp core config --dbname="$DB_NAME" --dbuser="$DB_USER_NAME" --dbpass="$DB_USER_PW" --dbhost="$DB_HOST:$DB_PORT" --dbprefix='wp_' --allow-root
    echo "WordPress database configured"

    # additionnal configuration for redis cache
    sed -i "s/.*WP_CACHE_KEY_SALT.*$/define\( 'WP_CACHE_KEY_SALT', 'mwagner.42.fr' \);/" /var/www/wordpress/wp-config.php
    sed -i "s/\"stop editing\" line. \*\//&\ndefine( 'WP_REDIS_HOST', 'redis' );/" /var/www/wordpress/wp-config.php

    # Install WordPress
    wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_NAME" --admin_password="$WP_ADMIN_PW" --admin_email="$WP_ADMIN_MAIL" --allow-root
    echo "WordPress installed"

    # Create an additional user
    wp user create $WP_USER_NAME $WP_USER_MAIL --role='subscriber' --user_pass="$WP_USER_PW" --allow-root
    echo "WordPress user added"

    # Install a new theme (twentysixteen) and activate it
    wp theme install twentysixteen --allow-root
    wp theme activate twentysixteen --allow-root
        echo "WordPress theme 'twentysixteen' installed and activated"

    # Install redis-cache plugin and activate it
    wp plugin install redis-cache --activate
        echo "redis-cache plugin installed and activated"
fi

# Execute the command passed as arguments (CMD in Dockerfile)
exec "$@"
