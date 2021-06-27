FROM postgres:13-alpine

ARG PG_DB_VAR
ARG PG_ENV_VAR
ARG PG_USER_VAR
ARG PG_PASS_VAR

RUN mkdir -p /var/lib/postgresql/helloworld-app
COPY setup.sql /var/lib/postgresql/helloworld-app
COPY docker-entrypoint.sh /var/lib/postgresql/helloworld-app

RUN chown -R postgres /var/lib/postgresql/helloworld-app

USER postgres

RUN chmod +x /var/lib/postgresql/helloworld-app/docker-entrypoint.sh

ENV PG_DB=$PG_DB_VAR
ENV PG_ENV=$PG_ENV_VAR
ENV PG_USER=$PG_USER_VAR
ENV PG_PASS=$PG_PASS_VAR

ENTRYPOINT ["/var/lib/postgresql/helloworld-app/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]

