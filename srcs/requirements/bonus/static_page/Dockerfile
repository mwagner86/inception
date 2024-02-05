# Use Alpine Linux 3.18 as the base image
FROM alpine:3.18

# Set the working directory for the container
WORKDIR /var/hugo/static

# Update and install required packages
RUN apk update && apk upgrade && apk add --update --no-cache \
    hugo \
    git \
    shadow \
    && rm -f /var/cache/apk/*

# Create a new Hugo site and clone the theme
RUN hugo new site /var/hugo/static \
 	&&     cd /var/hugo/static \
 	&&     git clone https://github.com/vaga/hugo-theme-m10c themes/m10c \
 	&&     hugo new posts/presentation.md \
 	&&     hugo -b https://mwagner.42.fr/static \
	&& mkdir -p /var/hugo/static/content/about

# Copy configuration files and content


COPY    ./conf/config.toml        /var/hugo/static/config.toml
COPY    conf/formatting.md    /var/hugo/static/content/posts/formatting.md
COPY    conf/about.md           /var/hugo/static/content/about/index.md
COPY    conf/avatar.jpg         /var/hugo/static/themes/m10c/static/avatar.jpg

# Expose the default Hugo server port
EXPOSE 1313

# Set the default command to start Hugo server
CMD ["hugo", "server", \
    "--bind=0.0.0.0", \
    "--baseURL=https://mwagner.42.fr/static", \
    "-p", "1313", \
    "--logFile=/dev/stdout", \
    "--appendPort=false"]
