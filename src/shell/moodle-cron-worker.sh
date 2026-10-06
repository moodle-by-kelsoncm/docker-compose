#!/usr/bin/env bash

# Loop infinito de execução do cron do Moodle gerenciado pelo Supervisord
while true; do
    /usr/local/bin/php /var/www/html/admin/cli/cron.php --keep-alive=0 2>&1 | tee -a /var/log/moodle/cron.log
    sleep 60
done
