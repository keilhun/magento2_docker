#!/usr/bin/bash
source ./.env
docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento $1 $2 $3 $4 $4 $6