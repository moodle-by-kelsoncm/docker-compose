# Moodle em Docker (`kelsoncm/moodle`)

[![GitHub Repository](https://img.shields.io/badge/GitHub-moodle--by--kelsoncm%2Fdocker--compose-blue?logo=github)](https://github.com/moodle-by-kelsoncm/docker-compose)

Imagem Docker otimizada para o Moodle, pronta para ambientes de desenvolvimento e produção. Baseada na imagem oficial `php:8.3-apache-bookworm`, contendo todas as extensões PHP necessárias pré-instaladas, suporte a banco de dados PostgreSQL/MariaDB, probes de saúde e gerenciamento de processos via **Supervisord** (executando Apache2 e o Worker do Moodle Cron simultaneamente).

---

## 🚀 Recursos Principal

- **PHP 8.3 + Apache**: Baseada no Debian Bookworm com extensões PHP essenciais configuradas (`gd`, `intl`, `mysqli`, `pgsql`, `opcache`, `zip`, `soap`, `xmlrpc`, `ldap`, etc.).
- **Cron Integrado**: Execução automática do `cron.php` do Moodle via worker gerenciado pelo Supervisord sem a necessidade de contêineres adicionais ou cronjobs no host.
- **Configuração Automática por Variáveis de Ambiente**: Instalação e conexão com banco de dados totalmente automatizadas via variáveis `CFG_*`.
- **Probes de Saúde e Monitoramento**: Endpoints nativos em `/probes` para monitoramento de disponibilidade, banco de dados e cron.

---

## 📋 Exemplo de `docker-compose.yml`

```yaml
services:
  db:
    image: postgres:17-alpine
    ports:
      - "5417:5432"
    environment:
      - POSTGRES_HOST=db
      - POSTGRES_PORT=5432
      - POSTGRES_DATABASE=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    command: >
      -c work_mem=500MB -c maintenance_work_mem=500MB -c max_wal_size=10GB
    volumes:
      - moodle_db:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD", "psql", "-h", "127.0.0.1", "-U", "postgres"]
      interval: 3s
      timeout: 3s
      retries: 3
      start_period: 10s

  moodle:
    image: kelsoncm/moodle:5.3.0.001
    ports:
      - "8080:80"
    environment:
      # Conexão com o Banco de Dados
      - CFG_DBHOST=db
      - CFG_DBPORT=5432
      - CFG_DBNAME=postgres
      - CFG_DBUSER=postgres
      - CFG_DBPASS=postgres
      - CFG_PREFIX=mdl_

      # Parâmetros da Aplicação
      - CFG_WWWROOT=http://localhost:8080
      - CFG_ENV=local
      - CFG_DEBUG=false

      # Credenciais do Administrador (utilizados na instalação automática inicial)
      - CFG_ADMINUSER=admin
      - CFG_ADMINPASS=admin
      - CFG_ADMINEMAIL=admin@server.local
      - CFG_FULLNAME=Meu Moodle
      - CFG_SHORTNAME=Meu Moodle

      # Probes de Saúde
      - CFG_PROBES_TOKEN=changeme
      - CFG_PROBES_POSTGRESQL=true
      - CFG_PROBES_CRONJOB=true
      - CFG_PROBES_TASKS=true
    volumes:
      - moodle_data:/var/www/moodledata
      - moodle_logs:/var/log/moodle
      - moodle_apache2logs:/var/log/apache2
    depends_on:
      db:
        condition: service_healthy

volumes:
  moodle_db:
  moodle_data:
  moodle_logs:
  moodle_apache2logs:
```

---

## ⚙️ Variáveis de Ambiente (`CFG_*`)

### Banco de Dados & Conexão
| Variável | Descrição | Valor Padrão |
| :--- | :--- | :--- |
| `CFG_DBHOST` | Host do banco de dados | `db` |
| `CFG_DBPORT` | Porta do banco de dados | `5432` |
| `CFG_DBNAME` | Nome do banco de dados | `postgres` |
| `CFG_DBUSER` | Usuário do banco de dados | `postgres` |
| `CFG_DBPASS` | Senha do banco de dados | `postgres` |
| `CFG_PREFIX` | Prefixo das tabelas | `mdl_` |

### Aplicação
| Variável | Descrição | Valor Padrão |
| :--- | :--- | :--- |
| `CFG_WWWROOT` | URL pública de acesso ao Moodle | `http://localhost:8080` |
| `CFG_ENV` | Ambiente (`local`, `dev`, `prod`) | `local` |
| `CFG_DEBUG` | Habilita modo de depuração no Moodle | `false` |

### Instalação Automática Inicial
| Variável | Descrição |
| :--- | :--- |
| `CFG_ADMINUSER` | Usuário administrador inicial |
| `CFG_ADMINPASS` | Senha do administrador inicial |
| `CFG_ADMINEMAIL` | E-mail do administrador |
| `CFG_FULLNAME` | Nome completo do site |
| `CFG_SHORTNAME` | Nome curto do site |

---

## 🛠️ Comandos Úteis

### Limpar caches do Moodle:
```bash
docker compose exec -T moodle php admin/cli/purge_caches.php
```

### Executar atualização via CLI:
```bash
docker compose exec -T moodle php admin/cli/upgrade.php --non-interactive
```

### Ver status dos processos (Supervisord):
```bash
docker compose exec moodle supervisorctl status
```

### Reiniciar o worker do Moodle Cron:
```bash
docker compose exec moodle supervisorctl restart moodle-cron
```

---

## 📄 Licença e Código Fonte

O código fonte desta imagem e os arquivos de orquestração estão mantidos no GitHub:
[https://github.com/moodle-by-kelsoncm/docker-compose](https://github.com/moodle-by-kelsoncm/docker-compose)
