FROM postgres:latest
RUN mkdir /var/lib/postgresql/ts_hdd/ /var/lib/postgresql/ts_ssd/ && chown -R postgres:postgres /var/lib/postgresql/
