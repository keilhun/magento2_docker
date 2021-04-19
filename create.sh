#!/usr/bin/bash
docker exec -w /app/public php_server php -d memory_limit=-1 /usr/local/bin/composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.3.6 .
docker exec php_server chmod 777 -R /app/public
cp ./docker/auth.json ./app/public
docker-compose down
docker-compose up -d
docker exec -w /app/public php_server php -d memory_limit=-1 bin/magento setup:install --base-url=http://127.0.0.1/ --db-host=mysql --db-name=magento --db-user=maguser --db-password=secret --admin-firstname=Magento --admin-lastname=User --admin-email=keil@khunsaker.com --admin-user=globale --admin-password=globalE1 --backend-frontname=admin --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1
docker exec -w /app/public php_server php -d memory_limit=-1 bin/magento sampledata:deploy
cp ./docker/nginx.conf.sample ./app/public
docker-compose down
docker-compose up -d
source deploy.sh