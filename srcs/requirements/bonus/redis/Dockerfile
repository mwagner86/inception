# Use Alpine Linux 3.18 as the base image
FROM alpine:3.18

# Expose port 3306 for redis
EXPOSE 6379

RUN apk update \
    && apk add --no-cache redis \
    && rm -rf /var/cache/apk/*

COPY ./tools/redis.sh /tmp/redis.sh

EXPOSE 6379

CMD ["sh", "/tmp/redis.sh"]