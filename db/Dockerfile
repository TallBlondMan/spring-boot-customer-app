FROM mysql
COPY create.sql /docker-entrypoint-initdb.d

COPY docker-healthcheck.sh docker-healthcheck.sh
# Moved from docker-compose file, ensures that whenever the container is started this will run again
# as opposed to run from compose only when it's started
HEALTHCHECK --interval=5s --timeout=3s --start-period=5s --retries=3 \
    CMD [ "./docker-healthcheck.sh" ]