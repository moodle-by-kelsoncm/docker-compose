Usage Guide
===========

Useful Commands
---------------

Start Moodle environment:
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose up -d

View application container logs:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose logs -f moodle

Run Moodle CLI upgrade in container:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose exec -T moodle php admin/cli/upgrade.php --non-interactive

Purge Moodle caches:
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose exec -T moodle php admin/cli/purge_caches.php

Inspect managed process status (Supervisord):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose exec moodle supervisorctl status
