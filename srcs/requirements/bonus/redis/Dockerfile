# Use Alpine Linux 3.18 as the base image
FROM alpine:3.18

# Expose port 6379 for Redis
EXPOSE 6379

# Add redis user and group with current host user ID and group ID
ARG GROUP_ID
ARG USER_ID
RUN addgroup -S -g ${GROUP_ID} redis \
    && adduser -S -G redis -u ${USER_ID} redis \
    && apk update && apk upgrade && apk add --update --no-cache \
        redis \
        shadow \
    && rm -rf /var/cache/apk/* \
    && chown -R redis:redis /run/redis/ /var/lib/redis

# Copy configuration file
COPY conf/redis.conf /etc/

# Launch Redis server with the specified configuration file
USER redis

CMD ["redis-server", "/etc/redis.conf"]