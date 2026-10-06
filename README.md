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

O repositório possui um workflow do GitHub Actions (`.github/workflows/deploy.yml`) para publicar automaticamente a imagem Docker no Docker Hub em `kelsoncm/moodle:<tagname>` sempre que uma tag git for criada e enviada (push).

### Variáveis / Segredos necessários no GitHub:
Configure as seguintes variáveis de segredo (Secrets) no repositório GitHub em **Settings -> Secrets and variables -> Actions**:
- `DOCKERHUB_USERNAME`: Nome de usuário do Docker Hub (ex.: `kelsoncm`).
- `DOCKERHUB_TOKEN`: Personal Access Token (PAT) ou senha do Docker Hub com permissão de escrita.

