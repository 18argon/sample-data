## Postgres

Create a derived [Postgres Server](https://www.postgresql.org/) [docker image](https://hub.docker.com/_/postgres/) containing an initialized `test.contacts` table with all data stored in a docker volume.

See `make help` for build details.

After build and run, you can connect to Percona Server on `localhost:5432` with `test`/`test` or `postgres `/`postgres`.

## Connection info

| Name | Value  |
|--- |--- |
| user | postgres |
| password | postgress |
| database | test |
| schema | test |
| port | 5432 |


## Run a container

```bash
docker run -d --name percona-sample-data \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=postgres \
    stevetarver/percona-sample-data:5.7-r0
```

## Fetch data from command line

```
docker exec -it $(IMAGE_NAME) \
    psql postgres://test:dGVzdA==@localhost/test -t -c 'SELECT COUNT(*) FROM test.contacts;'
```
