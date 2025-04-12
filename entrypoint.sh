#!/bin/sh
set -e

# Check if the PROJECT_NAME environment variable is set
if [ -z "$PROJECT_NAME" ]; then
    echo "Error: PROJECT_NAME variable is not set. Please set it via docker-compose or another method."
    exit 1
fi

# if set PROJECT_DIR_CONTAINER -> PROJECT_DIR="$PROJECT_DIR_CONTAINER" else PROJECT_DIR="/var/www/$PROJECT_NAME"
if [ -n "$PROJECT_DIR_CONTAINER" ]; then
    PROJECT_DIR="$PROJECT_DIR_CONTAINER"
else
    PROJECT_DIR="/var/www/$PROJECT_NAME"
fi

# If the project directory does not exist or is empty, create a new Symfony project
if [ ! -d "$PROJECT_DIR" ] || [ -z "$(ls -A "$PROJECT_DIR" 2>/dev/null)" ]; then
    echo "Project '$PROJECT_NAME' not found or is empty. Creating a new Symfony project..."
    composer create-project symfony/skeleton "$PROJECT_DIR" --no-interaction

    # Change to project directory and install additional packages
    cd "$PROJECT_DIR"
    echo "Installing Symfony ORM Pack..."
    composer require symfony/orm-pack
    echo "Installing Symfony Maker Bundle (dev)..."
    composer require --dev symfony/maker-bundle

    # Automatically generate or update .env.dev with DATABASE_URL if not already set
    ENV_FILE="$PROJECT_DIR/.env.dev"
    DB_URL="DATABASE_URL=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@db_${PROJECT_NAME}:3306/${MYSQL_DATABASE}?serverVersion=mariadb"
    if [ -f "$ENV_FILE" ]; then
        if grep -q "^DATABASE_URL=" "$ENV_FILE"; then
            echo "DATABASE_URL already exists in $ENV_FILE"
        else
            echo "$DB_URL" >> "$ENV_FILE"
            echo "DATABASE_URL added to $ENV_FILE"
        fi
    else
        echo "$DB_URL" > "$ENV_FILE"
        echo "$ENV_FILE created with DATABASE_URL"
    fi
else
    cd "$PROJECT_DIR"
fi

# Install Symfony CLI CA certificate if needed
echo "Installing Symfony CLI CA (if needed)..."
symfony server:ca:install --quiet || true

# Start the Symfony server on port ${SYMFONY_SERVER_PORT} with --allow-all-ip in the background
echo "Starting Symfony server on port ${SYMFONY_SERVER_PORT} with --allow-all-ip..."
symfony server:start --port=${SYMFONY_SERVER_PORT} --allow-all-ip &
SERVER_PID=$!

# Wait briefly to allow the server to start
sleep 2

# Start the Symfony local proxy in the background
echo "Starting Symfony local proxy..."
symfony proxy:start &
PROXY_PID=$!

# Attach the custom domain (using the PROJECT_NAME as the domain) to the Symfony server
echo "Attaching domain ${PROJECT_NAME} to the Symfony server..."
symfony proxy:domain:attach ${PROJECT_NAME} || echo "Domain attachment failed."

# Wait for the server process to end
wait $SERVER_PID
