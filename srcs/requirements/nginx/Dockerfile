# Use Alpine Linux 3.18 as the base image
FROM alpine:3.18

ARG DOMAIN_NAME
ARG CERTS

# Expose port
EXPOSE 443

# Install NGINX and OpenSSL
RUN apk update && apk upgrade && apk add --no-cache nginx openssl sed

# Generate a self-signed SSL certificate
RUN mkdir -p $CERTS

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $CERTS/nginx.key \
    -out $CERTS/nginx.crt \
    -subj "/C=DE/ST=Niedersachsen/L=Wolfsburg/O=42WOB/CN=mwagner/"

# Copy the custom nginx.conf file to the NGINX configuration directory
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy the HTML file to the NGINX default web root
# COPY index.html /usr/share/nginx/html/

RUN sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" /etc/nginx/nginx.conf \
&&  sed -i "s%CERTS%$CERTS%g" /etc/nginx/nginx.conf

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
