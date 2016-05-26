#!/bin/bash

# Capturamos la fecha actual en formato yyy-mm-dd
today=$(date +%Y-%m-%d)

# Generamos el nombre que va a tener el archivo sql
# por ejemplo mydb-2016-09-29.sql
# la variable $POSTGRES_DB la toma de las variables de entorno
# que pasamos en el docker-compose.yml
filename="$POSTGRES_DB-$today.sql"

# Generamos el dump de la base de datos y lo guardamos en un archivo
# con el nombre que definimos antes
pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER --no-password $POSTGRES_DB > /tmp/$filename

# Para subir un archivo a dropbox basta con hacer un POST a la API url
# con un access token
curl -X POST https://content.dropboxapi.com/2/files/upload \
	-H "Authorization: Bearer $DROPBOX_ACCESS_TOKEN" \
	-H "Dropbox-API-Arg: {\"path\": \"/$filename\", \"mode\": \"add\",\"autorename\": true,\"mute\": false}" \
	-H "Content-Type: application/octet-stream" \
	--data-binary @/tmp/$filename
