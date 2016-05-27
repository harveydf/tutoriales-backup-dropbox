# Basamos nuestra imagen en la postgres
# esto es importante porque necesitamos el
# comando de pg_dump que viene en dicha imagen
FROM postgres

# Actualizamos los repositorios e instalamos curl
RUN apt-get update && apt-get -y install curl

# Copiamos el script que hace los backups en el root 
COPY backup.sh /

# Copiamos el archivo con el cronjob en /etc/cron.d/
COPY cron-backup /etc/cron.d/

# Creamos el archivo de log para el cron
RUN touch /var/log/cron.log

# Copiamos el script de configuracion en el root
COPY docker-entrypoint.sh /

# Usamos el entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

# Ejecutamos el comando cron para que corra el cron job
# dentro de cron-backup
# El comando tail nos ayuda a mantener vivo el contenedor
# y que no salga despues de ejecutar "cron"
CMD cron && tail -f /var/log/cron.log
