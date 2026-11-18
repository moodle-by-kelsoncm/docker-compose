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

PHPUnit (``dev`` stage)
-----------------------

The ``dev`` stage ships the core composer development dependencies (``vendor/bin/phpunit``) and ``opcache.enable_cli=1``.
PHPUnit is enabled in ``config.php`` only when ``CFG_PHPUNIT_DATAROOT`` is set; without it nothing changes.

- ``CFG_PHPUNIT_DATAROOT``: ``$CFG->phpunit_dataroot``. Prefer a ``tmpfs`` path (e.g. ``/var/phpunitdata``).
- ``CFG_PHPUNIT_PREFIX``: ``$CFG->phpunit_prefix`` (default ``phpu_``). Must differ from ``CFG_PREFIX``.
- ``CFG_PHPUNIT_DIRECTORYPERMISSIONS``: ``$CFG->phpunit_directorypermissions``, in octal (e.g. ``02777``).
- ``CFG_PHPUNIT_PROFILINGENABLED``: ``$CFG->phpunit_profilingenabled`` (default ``false``).

Then, as ``www-data``: ``php admin/tool/phpunit/cli/init.php`` and ``vendor/bin/phpunit <file or --filter>``.
