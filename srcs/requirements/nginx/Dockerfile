# Use Alpine Linux 3.18 as the base image
FROM alpine:3.18

# Install NGINX and OpenSSL
RUN apk --no-cache add nginx openssl

# Generate a self-signed SSL certificate
RUN mkdir /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/mwagner.key \
    -out /etc/nginx/ssl/certificate.crt \
    -subj "/C=DE/ST=Niedersachsen/L=Wolfsburg/O=Organization/CN=mwagner/"

# Copy the custom nginx.conf file to the NGINX configuration directory
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy the HTML file to the NGINX default web root
COPY index.html /usr/share/nginx/html/

# Expose port
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
