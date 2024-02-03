# Use Alpine Linux 3.18 as the base image
FROM alpine:3.18

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Update package index and install required packages
RUN apk update && \
    apk add --no-cache \
        php81 \
        php-fpm \
        php-common \
        php-json \
        php-session \
        php-mysqli \
        php81-phar \
        php81-iconv \
        php81-mbstring \
        curl

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create www-data user
RUN adduser -S www-data && \
    adduser www-data www-data

# Copy PHP-FPM configuration
COPY ./conf/www.conf /etc/php81/php-fpm.d/www.conf

# Create directory for WordPress
RUN mkdir -p /var/www/wordpress

# Copy tool.sh script
COPY ./tools/tool.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/tool.sh

# Set entry point to the tool.sh script
ENTRYPOINT ["/usr/local/bin/tool.sh"]

# Set working directory to /var/www/wordpress
WORKDIR /var/www/wordpress

# Start PHP-FPM in foreground
CMD ["/usr/sbin/php-fpm81", "-F"]
