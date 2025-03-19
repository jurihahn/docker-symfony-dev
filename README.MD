# Symfony Dev Docker Image

This repository provides a Docker image to quickly set up a Symfony development environment. The image automatically creates a new Symfony project (if not already present), starts the Symfony CLI server with TLS support, and sets up a local proxy for domain-based testing.

## Quick Start

1. **Clone this Repository**

   Clone this repository or download the Dockerfile, entrypoint.sh, and docker-compose.yml files.

2. **Configure the Project Name**

   Create a `.env` file (if it doesn't already exist) and define your project name:

   ```dotenv
   PROJECT_NAME=my_symfony_app
