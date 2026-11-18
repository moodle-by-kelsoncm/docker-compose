# Exemplo de Moodle em imagem Docker e usando Docker Compose


```bash
git clone https://github.com/kelsoncm/moodle_workspace.git
cd moodle_workspace
docker compose build
docker compose up
```

Não se esqueça de alterar o arquivo `docker-compose.yml`, especialmente a `image:` para um nome de imagem que você deseja.

```
services:
# ...
    moodle:
        image: meu/moodle:5.3.0.002
```

## Observações
1. Novos plugins são instalados baixando da **Moodle Plugins Directory** e colocando na pasta `build/plugins`.
2. A pasta `build/plugins` ficam os código udando apenas em tempo de **construção**.
3. A pasta `src`  ficam os código udando apenas em tempo de **execução**.
4. Se optar, publique a imagem no Docker Hub com `docker compose push`, certifique-se de primeiro fazer login no repositório.

## CI/CD

O repositório possui um workflow do GitHub Actions (`.github/workflows/deploy.yml`) para
publicar automaticamente as imagens Docker no Docker Hub sempre que uma tag git for criada:
- `kelsoncm/moodle:<tagname>`: Imagem de produção (baseada no estágio `prod`).
- `kelsoncm/moodle-for-dev:<tagname>`: Imagem para desenvolvimento (estágio `dev`),
  com Node.js 22, Grunt CLI, Composer, moodle-cs, PHPUnit 11, PCOV e Xdebug.

### Variáveis / Segredos necessários no GitHub:
Configure as seguintes variáveis de segredo (Secrets) no repositório GitHub
em **Settings -> Secrets and variables -> Actions**:
- `DOCKERHUB_USERNAME`: Nome de usuário do Docker Hub (ex.: `kelsoncm`).
- `DOCKERHUB_TOKEN`: Personal Access Token (PAT) ou senha do Docker Hub com permissão de escrita.


## PHPUnit (estágio `dev`)

O estágio `dev` já vem pronto para rodar o PHPUnit do core e de plugins:

- dependências de desenvolvimento do composer do core instaladas (`moodle/moodle-testing`, com `vendor/bin/phpunit`);
- `opcache.enable_cli=1` (arquivo `30-opcache-dev.ini`), o que acelera a suíte, que roda num único processo.

O PHPUnit só é habilitado no `config.php` quando estas variáveis de ambiente são definidas. Sem `CFG_PHPUNIT_DATAROOT`, nada muda:

| Variável | Padrão | Descrição |
| :--- | :--- | :--- |
| `CFG_PHPUNIT_DATAROOT` | (vazia) | `$CFG->phpunit_dataroot`. Use um caminho em `tmpfs` (ex.: `/var/phpunitdata`). |
| `CFG_PHPUNIT_PREFIX` | `phpu_` | `$CFG->phpunit_prefix`. Precisa ser diferente de `CFG_PREFIX`. |
| `CFG_PHPUNIT_DIRECTORYPERMISSIONS` | (vazia) | `$CFG->phpunit_directorypermissions`, em octal (ex.: `02777`). |
| `CFG_PHPUNIT_PROFILINGENABLED` | `false` | `$CFG->phpunit_profilingenabled`. |

Exemplo de serviço em `docker-compose.yml`:

```yaml
    moodle:
        build:
            context: .
            target: dev
        environment:
            - CFG_PHPUNIT_DATAROOT=/var/phpunitdata
            - CFG_PHPUNIT_PREFIX=phpu_
        tmpfs:
            - /var/phpunitdata:uid=33,gid=33,mode=0770,size=2g
```

Inicialize e rode (como `www-data`):

```bash
php admin/tool/phpunit/cli/init.php
vendor/bin/phpunit public/user/tests/table/participants_search_test.php
vendor/bin/phpunit --filter participants_search_test
```

Dicas de desempenho: mantenha o core dentro da imagem (sem bind mount), o `phpunit_dataroot` em `tmpfs`
e, num banco de desenvolvimento descartável, desligue `fsync`, `synchronous_commit` e `full_page_writes` do PostgreSQL.
