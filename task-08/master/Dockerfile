FROM postgres:13

COPY ./pg_hba.conf /var/lib/postgresql/
COPY ./postgresql.conf /etc/postgresql/
COPY ./init.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/init.sh

CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]
