############################
## Imagem base
####################################################################################
FROM php:8.3.24-apache-bookworm AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV MOODLE_VERSION=5.3.0
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

ADD build/php-extensions.sh             /tmp/build/php-extensions.sh
ADD build/locale.gen                    /etc/locale.gen
ADD src/ini/                            /usr/local/etc/php/conf.d/
ADD src/shell/                          /usr/local/bin/

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN    /tmp/build/php-extensions.sh \
    && chmod 777 /tmp \
    && chmod +t /tmp \
    && curl -L https://github.com/moodle/moodle/archive/refs/tags/v$MOODLE_VERSION.tar.gz | tar -zx --strip-components=1 \
    && export COMPOSER_ALLOW_SUPERUSER=1 \
    && composer install --no-dev --classmap-authoritative --no-interaction \
    && composer clear-cache \
    && mkdir -p /var/moodledata /var/www/moodledata \
    && chown -R www-data:www-data /var/moodledata /var/www \
    && chmod 775 /var/moodledata \
    && chmod -R 755 /var/www \
    && mkdir -p /var/log/moodle      && chown -R www-data:www-data /var/log/moodle \
    && mkdir -p /var/log/apache2     && chown -R www-data:www-data /var/log/apache2 \
    && mkdir -p /var/log/supervisor  && chown -R root:root /var/log/supervisor \
    && chmod +x /usr/local/bin/*

ADD src/supervisor/                     /etc/supervisor/

ADD --chown=www-data:www-data src/php/ /var/www/html/
RUN ln -s /var/www/html/probes /var/www/html/public/probes \
    && printf '<IfModule mod_dir.c>\n    DirectoryIndex index.php index.html\n</IfModule>\n<IfModule mod_negotiation.c>\n    Options -MultiViews\n</IfModule>\nFallbackResource /r.php\n' > /var/www/html/public/.htaccess \
    && chown www-data:www-data /var/www/html/public/.htaccess \
    && printf '<Directory /var/www/html/public>\n    AllowOverride All\n    FallbackResource /r.php\n</Directory>\n' >> /etc/apache2/conf-available/docker-php.conf \
    && a2enconf docker-php

ADD build/moodle-install-package.sh     /tmp/build/moodle-install-package.sh
ADD build/plugins                 /tmp/build/plugins
USER www-data
WORKDIR /tmp/build/plugins
RUN for plugin in *.zip ; do [ -f "$plugin" ] && /tmp/build/moodle-install-package.sh "$plugin" || true; done

USER root
WORKDIR /var/www/html
EXPOSE 80
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]


############################
## STAGE: dev
############################
FROM base AS dev

ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=22.11.0
ENV PATH=${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:${PATH}

ARG NVM_INSTALL_SHA256="2d8359a64a3cb07c02389ad88ceecd43f2fa469c06104f92f98df5b6f315275f"
ARG PHPUNIT_11_PHAR_SHA256="9d58674e826904add392d08c5ba3e9173ff36b242683cd8f368a476d2513b3bd"

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        curl \
        ca-certificates \
        git \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ${NVM_DIR} \
    && curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o /tmp/nvm-install.sh \
    && echo "${NVM_INSTALL_SHA256}  /tmp/nvm-install.sh" | sha256sum -c - \
    && bash /tmp/nvm-install.sh \
    && rm -f /tmp/nvm-install.sh \
    && . ${NVM_DIR}/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm use ${NODE_VERSION} \
    && npm install -g grunt-cli

RUN export COMPOSER_ALLOW_SUPERUSER=1 \
    && mkdir -p /opt/phpcs \
    && cd /opt/phpcs \
    && composer init --no-interaction \
    && composer config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true \
    && composer require moodlehq/moodle-cs \
    && ln -s /opt/phpcs/vendor/bin/phpcs /usr/local/bin/phpcs \
    && ln -s /opt/phpcs/vendor/bin/phpcbf /usr/local/bin/phpcbf

RUN curl -fL https://phar.phpunit.de/phpunit-11.phar -o /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

RUN pecl install xdebug \
    && rm -rf /tmp/pear

RUN echo "pcov.enabled=1" >> /usr/local/etc/php/conf.d/20-pcov.ini \
    && echo "pcov.directory=." >> /usr/local/etc/php/conf.d/20-pcov.ini

USER root
WORKDIR /var/www/html
EXPOSE 80
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]


############################
## STAGE: prod
############################
FROM base AS prod
