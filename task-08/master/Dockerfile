FROM postgres:13
COPY ./init.sh /docker-entrypoint-initdb.d/
COPY ./pg_hba.conf /var/lib/postgresql/
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
