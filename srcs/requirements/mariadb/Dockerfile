# Use Alpine Linux 3.18 as the base image
FROM alpine:3.18

# Expose port 3306 for MySQL
EXPOSE 3306

# Update package index and install MariaDB server and client
RUN apk update && apk add --no-cache mariadb mariadb-client

# Enable networking in MariaDB
RUN sed -i "s/skip-networking/skip-networking=0/g" /etc/my.cnf.d/mariadb-server.cnf

# Create directories and set permissions
RUN mkdir -p /var/run/mysqld && \
    chmod 777 /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

# Copy SQL script and setup script
COPY ./conf/db_create.sql /var/mariadb/
COPY ./tools/maria_setup.sh /var/mariadb/

# Set permissions for the scripts
RUN chmod 777 /var/mariadb/db_create.sql && \
    chmod 777 /var/mariadb/maria_setup.sh

# Set the entry point and default command
ENTRYPOINT ["/var/mariadb/maria_setup.sh"]
CMD ["/usr/bin/mysqld", "--user=mysql", "--init-file=/var/mariadb/db_create.sql"]
