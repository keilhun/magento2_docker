#!/usr/bin/bash
source ./.env
docker exec -w /app/public php_server-$APP_EXT $1 $2 $3 $4 $4 $6