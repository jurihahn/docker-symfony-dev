FROM php:8.4-cli-alpine

LABEL maintainer="Juri Hahn <juri@hahn21.de>"

# Install required packages: git, unzip, wget (needed for installing Symfony CLI)
RUN apk add --no-cache git unzip wget

# Install PHP zip extension
RUN docker-php-ext-install zip

# Install Composer by copying it from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | sh && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Set working directory
WORKDIR /var/www

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 8000 for the Symfony server
EXPOSE 8000

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command is empty because the entrypoint handles launching
CMD []
