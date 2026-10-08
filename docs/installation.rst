Instalação & Requisitos
=======================

Requisitos
----------

- **Docker Engine**: 20.10+
- **Docker Compose**: v2.0+
- **Git**

Passo a Passo
-------------

1. Clone o repositório em sua máquina de desenvolvimento:

   .. code-block:: bash

      git clone https://github.com/moodle-by-kelsoncm/docker-compose.git
      cd docker-compose

2. Verifique o arquivo `docker-compose.yml` e personalize o nome da imagem caso necessário:

   .. code-block:: yaml

      services:
        moodle:
          image: meu/moodle:5.3.0.002

3. Construa as imagens e inicie os contêineres:

   .. code-block:: bash

      docker compose build
      docker compose up -d
