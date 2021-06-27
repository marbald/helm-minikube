#!/bin/bash

chmod 0700 /var/lib/postgresql/data
initdb /var/lib/postgresql/data
echo "host all      all        0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf
echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

pg_ctl -D /var/lib/postgresql/data start

psql -U postgres -c "CREATE ROLE $PG_USER WITH LOGIN PASSWORD '$PG_PASS'";
psql -U postgres -c "CREATE DATABASE $PG_DB WITH OWNER $PG_USER"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $PG_DB TO $PG_USER;"
psql -U $PG_USER -d $PG_DB -f /var/lib/postgresql/helloworld-app/setup.sql -v env="'${PG_ENV}'"

pg_ctl -D "/var/lib/postgresql/data" -m fast -w stop

exec "$@"
