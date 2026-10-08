Configuration
=============

Directory Structure
-------------------

- **build/plugins**: Additional Moodle plugins placed here are baked directly into the Docker image build.
- **src**: Contains scripts and configuration files copied to the container:
  - **src/supervisor**: ``supervisord.conf`` process manager file (Apache2 and background cron worker).
  - **src/shell**: Utility initialization (``docker-php-entrypoint``) and loop execution scripts (``moodle-cron-worker.sh``).
  - **src/ini**: PHP runtime custom settings (``20-local.ini``).
  - **src/php**: Health probes, deployment, and database connection logic.

Environment Variables
---------------------

Database parameters (MariaDB / PostgreSQL), HTTP/HTTPS exposed ports, and data upload volumes are managed directly within ``docker-compose.yml``.
