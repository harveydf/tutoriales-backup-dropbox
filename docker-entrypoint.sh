#!/bin/bash

set -e

# la estructura del archivo es hostname:port:database:username:password
echo "$POSTGRES_HOST:5432:$POSTGRES_DB:$POSTGRES_USER:$POSTGRES_PASSWORD" > ~/.pgpass

chmod 600 ~/.pgpass

exec "$@"
