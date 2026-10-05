# Configuração — moodle-docker_compose

## Estrutura de Diretórios

- **`build/plugins`**: Novos plugins baixados do repositório Moodle colocados aqui serão integrados na construção da imagem.
- **`src`**: Contém configurações e scripts integrados à imagem:
  - **`src/supervisor`**: Arquivo `supervisord.conf` para orquestração de processos (Apache2 e worker de cron).
  - **`src/shell`**: Scripts utilitários de inicialização (`docker-php-entrypoint`) e execução contínua (`moodle-cron-worker.sh`).
  - **`src/ini`**: Configurações adicionais de PHP (`20-local.ini`).
  - **`src/php`**: Configurações de probes, deploy e conexão com banco.

## Variáveis de Ambiente

As variáveis de banco de dados (ex: MariaDB/PostgreSQL), portas HTTP/HTTPS e volume de uploads são configuráveis no `docker-compose.yml`.
