FROM mysql
COPY create.sql /docker-entrypoint-initdb.d
EXPOSE 3306

COPY docker-healthcheck.sh docker-healthcheck.sh
RUN chmod +x docker-healthcheck.sh
# Moved from docker-compose file, ensures that whenever the container is started this will run again
# as opposed to run from compose only when it's started
HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 \
    CMD [ "./docker-healthcheck.sh" ]