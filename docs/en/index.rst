Overview - moodle-docker-compose
=================================

**moodle-docker-compose** is a pre-configured **Docker Compose** containerized environment for orchestrating, running, and quickly testing Moodle instances and plugins in a local development environment.

Key Features
------------

- **Complete Moodle + Database Stack**: Rapid setup of Moodle PHP/Apache containers and database services.
- **Build vs Runtime Separation**:
  - `build/plugins` directory for packages baked into image builds.
  - `src` directory for live source code volume mounting.
- **Docker Hub Ready**: Scripts and configurations prepared for building and pushing customized images.

Documentation
-------------

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   installation
   configuration
   usage
