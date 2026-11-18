Configuração
============

Estrutura de Diretórios
-----------------------

- **build/plugins**: Novos plugins baixados do repositório Moodle colocados aqui serão integrados na construção da imagem.
- **src**: Contém configurações e scripts integrados à imagem:
  - **src/supervisor**: Arquivo `supervisord.conf` para orquestração de processos (Apache2 e worker de cron).
  - **src/shell**: Scripts utilitários de inicialização (`docker-php-entrypoint`) e execução contínua (`moodle-cron-worker.sh`).
  - **src/ini**: Configurações adicionais de PHP (`20-local.ini`).
  - **src/php**: Configurações de probes, deploy e conexão com banco.

Variáveis de Ambiente
---------------------

As variáveis de banco de dados (ex: MariaDB/PostgreSQL), portas HTTP/HTTPS e volume de uploads são configuráveis no `docker-compose.yml`.

PHPUnit (estágio ``dev``)
-------------------------

O estágio ``dev`` traz as dependências de desenvolvimento do composer do core (``vendor/bin/phpunit``) e ``opcache.enable_cli=1``.
O PHPUnit só é habilitado no ``config.php`` quando ``CFG_PHPUNIT_DATAROOT`` está definida; sem ela, nada muda.

- ``CFG_PHPUNIT_DATAROOT``: ``$CFG->phpunit_dataroot``. Use um caminho em ``tmpfs`` (ex.: ``/var/phpunitdata``).
- ``CFG_PHPUNIT_PREFIX``: ``$CFG->phpunit_prefix`` (padrão ``phpu_``). Precisa ser diferente de ``CFG_PREFIX``.
- ``CFG_PHPUNIT_DIRECTORYPERMISSIONS``: ``$CFG->phpunit_directorypermissions``, em octal (ex.: ``02777``).
- ``CFG_PHPUNIT_PROFILINGENABLED``: ``$CFG->phpunit_profilingenabled`` (padrão ``false``).

Depois, como ``www-data``: ``php admin/tool/phpunit/cli/init.php`` e ``vendor/bin/phpunit <arquivo ou --filter>``.
