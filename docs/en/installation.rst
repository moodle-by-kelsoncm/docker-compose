Installation & Requirements
===========================

Requirements
------------

- **Docker Engine**: 20.10+
- **Docker Compose**: v2.0+
- **Git**

Step by Step
------------

1. Clone this repository on your workstation:

   .. code-block:: bash

      git clone https://github.com/moodle-by-kelsoncm/docker-compose.git
      cd docker-compose

2. Inspect `docker-compose.yml` and adjust image names as required:

   .. code-block:: yaml

      services:
        moodle:
          image: my/moodle:5.3.0.002

3. Build images and start containers:

   .. code-block:: bash

      docker compose build
      docker compose up -d
