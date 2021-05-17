#Docker container for Magento Development

##TL;DR
Run following commands to build and run magento 2
1. mkdir new_dir_name
2. cd new_dir_name
3. git clone https://github.com/keilhun/magento2_docker.git .
4. cp .env.example .env
5. cp ./docker/auth.json.example ./docker/auth.json
6. Edit .env to set appropriate variables
7. Edit auth.json to include your magento repo keys
8. docker-compose build
9. docker-compose up -d
10. ./create.sh
11. On web browser go to 127.0.0.1

After running the above commands you will have a fully functional Magento 2 installation with sample data installed.

##Explantion of steps
This container is set up to allow use of any development tool without requiring code to be uploaded when modified. Small changes should work right away, larger changes may need you to run ./deploy.sh to rebuild parts of the system.

This environment is designed for use on a linux environment, particularly WSL2 under Windows&trade;. Other than docker, should have a recent version of PHP installed on the host machine.  

The user needs to create two files based on the examples provided. These are .env and auth.json.

The .env file contains all of the necessary installation variables including userid password for the database. Most of the variables should be self explanatory but a couple are worth noting. The first two in the file COMPOSE_PROJECT_NAME and APP_EXT are used to differentiate one instance from another. They should be set to the same value. MYSQL_HOST should not be changed unless you have changed the docker-compose.yml file also. Biggest issue with this file is to make sure you pair the version of Magento with the appropriate version of PHP.

The auth.json file contains your credentials to access the magento repo. You can get these by registering at https://account.magento.com/customer/account/login.

Once the files are edited run ./create.sh. This script downloads and installs the appropriate magento version and installs the sample data. Next run docker-compose build and docker-compose up -d. Go to 127.0.0.1 in a browser and you should see the magento example site complete with sample data. Subsequent uses of the container can be run with just the docker-compose up -d command.

If you see any error when trying to bring up the site, try running ./deploy.sh.

##Helper Scripts
1. deploy.sh:
   - This script runs the following commands inside the appropriate docker container.
    chmod 777 -R /app/public
    php bin/magento cache:clean
    chmod 777 -R /app/public
    php bin/magento setup:upgrade
    chmod 777 -R /app/public
    php bin/magento setup:di:compile
    chmod 777 -R /app/public
    php bin/magento setup:static-content:deploy -f
    chmod 777 -R /app/public
2. dme.sh:
   - This script runs whatever magento command you need in the appropriate container (ex. dme cache:clean).
3. dexec.sh:
   - This script runs any command in the php container (ex dexec chmod 777 *).
   - If you need to run commands on the other containers, use the command in this script as an example and just substitute the appropriate container name.

##Troubleshooting
1. Unable to install admin during create.sh (message says there is already a user with the same name and different email address).
   - run docker volume ls
   - Find volume linked to this instance (will have value defined in APP_EXT variable in .env file in the volume name)
   - run docker-compose down followed by docker-compose up -d
   - delete entire app/public directory.
   - rerun create.sh
2. Any other issues during the running of create.sh
   - fix whatever the issue is and then delete entire app/public directory before rerunning create.sh