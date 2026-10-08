Visão Geral - moodle-docker-compose
===================================

O **moodle-docker-compose** é um ambiente containerizado pré-configurado com **Docker Compose** para orquestração, execução e testes rápidos de instâncias Moodle e seus plugins em ambiente de desenvolvimento local.

Recursos Principais
-------------------

- **Ambiente Completo Moodle + Banco de Dados**: Subida rápida de contêineres PHP/Apache Moodle e SGBD.
- **Separação de Build e Runtime**:
  - Diretório `build/plugins` para pacotes compilados na construção da imagem.
  - Diretório `src` para montagem de código em tempo de execução.
- **Pronto para Docker Hub**: Scripts e definições preparados para push de imagens personalizadas.

Documentação
------------

.. toctree::
   :maxdepth: 2
   :caption: Conteúdo:

   installation
   configuration
   usage
