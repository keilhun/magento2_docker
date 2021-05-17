#Docker container for Magento Development

##TL;DR;
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
This container is set up to allow use of any development tool without requiring code to be uploaded when modified. Small changes should work right away, larger changes may need you to run deploy.sh to rebuild parts of the system.

This environment is designed for use on Windows with WSL2 and docker installed. Further, php should be installed on WSL. 


