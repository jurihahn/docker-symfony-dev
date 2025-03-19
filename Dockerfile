FROM php:8.4-cli-alpine

LABEL maintainer="Juri Hahn <juri@hahn21.de>"

# Install required packages: git, unzip, wget, bash, libzip-dev, and zlib-dev
RUN apk add --no-cache git unzip wget bash libzip-dev zlib-dev

# Install PHP zip extension
RUN docker-php-ext-install zip

# Install Composer by copying it from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install Symfony CLI using bash for compatibility
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Set working directory
WORKDIR /var/www

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 8000 for the Symfony server
EXPOSE 8000

# Set the entrypoint and default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
