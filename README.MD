# Symfony Dev Environment with MariaDB and phpMyAdmin

This repository provides a complete Docker development environment for Symfony applications. It includes:

- **Symfony Container:** Automatically creates a new Symfony project if none exists, starts the Symfony CLI server (with TLS support and domain proxying), and mounts your project code.
- **MariaDB Container:** Runs a MariaDB database server for your application.
- **phpMyAdmin Container:** Provides a web-based interface to manage your MariaDB database.

All configuration settings (such as the project name and database credentials) are centralized in the `.env` file so that you only need to update values in one place.

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your machine.
- Basic understanding of Docker and Docker Compose.

---

## Getting Started

1. Download **docker-compose.yml** and **.env**
2. Edit **.env**:
   * Set projekt name
     ```dotenv 
     PROJECT_NAME=my_app_name
     ```
3. Start docker containers
   ```bash
   docker compose up -d
   ```
4. Stop docker containers
   ```bash
   docker compose down
   ```

## Configure Environment Variables (.env)
```dotenv
PROJECT_NAME=my_symfony_app
MYSQL_DATABASE=my_database
MYSQL_USER=my_db_user
MYSQL_PASSWORD=my_db_password
MYSQL_ROOT_PASSWORD=password
SYMFONY_SERVER_PORT=8000
SYMFONY_PROXY_PORT=7080
PHP_MY_ADMIN_PORT=8080
```
* **PROJECT_NAME**: The name of your Symfony project.
* **MYSQL_DATABASE**: Database for Symfony App.
* **MYSQL_USER**: Database user for Symfony App.
* **MYSQL_PASSWORD**: Database user password for Symfony App.
* **MYSQL_ROOT_PASSWORD**: The root password for the MariaDB container.
* **SYMFONY_SERVER_PORT**: The port on which the Symfony CLI server will run inside the container.
* **SYMFONY_PROXY_PORT**: The port on which the Symfony proxy will run.
* **PHP_MY_ADMIN_PORT**: The host port to access phpMyAdmin.

## Prepare the Application Directory
1. Place your application code (or an empty folder if starting fresh) in the `./app` directory.
2. The volume mapping in `docker-compose.yml` mounts `./app` to `/var/www/${PROJECT_NAME}` inside the container.

## Access Your Services
### **Symfony Application**:
Access your Symfony application in your browser at:
   * http://localhost:8000 (or the port specified by SYMFONY_SERVER_PORT), or
   * If using domain proxying with Symfony CLI, add an entry to your hosts file (e.g., 127.0.0.1 my_symfony_app) and visit https://my_symfony_app.
### **phpMyAdmin**:
Access phpMyAdmin at:
   * http://localhost:8080 (or the port specified by PHP_MY_ADMIN_PORT).
### **MariaDB**:
The MariaDB container stores its data in ./mariadb/mysql on the host. Use the credentials specified in the .env file to connect.

## Troubleshooting
### View Logs:
Use docker compose logs to see logs for all services or docker compose logs [service_name] (e.g., symfony, db, or phpmyadmin) for specific containers.
### Environment Variables:
Ensure your .env file is present in the project root and correctly formatted.
### Domain Proxying:
If you use domain proxying, remember to add a hosts file entry (e.g., 127.0.0.1 my_symfony_app) to access your Symfony application via its custom domain.

