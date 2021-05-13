#!/usr/bin/bash
source ./.env
docker exec php_server-$APP_EXT chmod 777 -R /app/public
docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento cache:clean
docker exec php_server-$APP_EXT chmod 777 -R /app/public
docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento setup:upgrade
docker exec php_server-$APP_EXT chmod 777 -R /app/public
docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento setup:di:compile
docker exec php_server-$APP_EXT chmod 777 -R /app/public
docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento setup:static-content:deploy -f
docker exec php_server-$APP_EXT chmod 777 -R /app/public
