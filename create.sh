#!/usr/bin/bash
source ./.env
mkdir ./app/public
docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 /usr/local/bin/composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=$MAGENTO_VERSION .
docker exec php_server-$APP_EXT chmod 777 -R /app/public
cp ./docker/auth.json ./app/public
docker-compose down
docker-compose up -d

# New install commands will probably have to be entered in the future if/when Magento adds more command line options
# version_check.php checks if Magento_Version is greater than or equal to 2.4 and returns 1 if so
if  [ `php ./docker/version_check.php $MAGENTO_VERSION 2.4` -eq "1" ];
then
    docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento setup:install --base-url=http://127.0.0.1/ --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --admin-firstname=Magento --admin-lastname=User --admin-email=$ADMIN_EMAIL --admin-user=$ADMIN_USER --admin-password=$ADMIN_PASSWORD --backend-frontname=admin --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200
else
    docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento setup:install --base-url=http://127.0.0.1/ --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --admin-firstname=Magento --admin-lastname=User --admin-email=$ADMIN_EMAIL --admin-user=$ADMIN_USER --admin-password=$ADMIN_PASSWORD --backend-frontname=admin --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1
fi
docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento sampledata:deploy
cp ./docker/nginx.conf.sample ./app/public
docker-compose down
docker-compose up -d
source deploy.sh
if  [ `php ./docker/version_check.php $MAGENTO_VERSION 2.4` -eq "1" ]; 
    then 
        docker exec -w /app/public php_server-$APP_EXT php -d memory_limit=-1 bin/magento module:disable Magento_TwoFactorAuth;
        source ./deploy.sh
fi
