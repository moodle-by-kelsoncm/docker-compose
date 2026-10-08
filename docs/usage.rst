Guia de Uso
===========

Comandos Úteis
--------------

Iniciar o ambiente Moodle:
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose up -d

Visualizar logs da aplicação:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose logs -f moodle

Executar CLI de atualização no contêiner:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose exec -T moodle php admin/cli/upgrade.php --non-interactive

Limpar caches do Moodle:
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose exec -T moodle php admin/cli/purge_caches.php

Visualizar status dos processos gerenciados (Supervisord):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose exec moodle supervisorctl status

Reiniciar o worker de cron:
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker compose exec moodle supervisorctl restart moodle-cron
