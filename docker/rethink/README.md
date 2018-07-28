## RethinkDB

Create a derived [RethinkDB](https://www.rethinkdb.com/) [docker image](https://hub.docker.com/_/rethinkdb/) containing an initialized `test.contacts` collection in a docker volume.

See `make help` for build details.

**NOTE:** The 'test' target requires 'recli': `npm install -g recli`

RethinkDB does not provide database initialization support. We could use RethinkDB's [bulk import support](https://www.rethinkdb.com/docs/importing/) and monkey-patch a docker-entrypoint.sh into the base image, but that requires installing python, pip, and the RethinkDB python driver increasing image size from 183MB to 256MB.

Instead, the build process creates a temp container with a mounted `/data` volume, installs required packages, and imports the contacts. Then, when building the final image, the temp container's `/data` is copied into the final image. The final image is a bit slimmer at 199MB.

## Connection info

| Name | Value  |
|--- |--- |
| user | |
| password | |
| table | contacts |
| schema | test |
| port | 28015 |


## Run a container

```bash
docker run -d --name rethink-sample-data \
    -p 8080:8080                        \
    -p 28015:28015                      \
    -p 29015:29015                      \
    stevetarver/rethink-sample-data:2.3.5
```

## Fetch data

RethinkDb ships with an excellent GUI at [http://localhost:8080/](http://localhost:8080/).

To fetch data from the command line, install 'recli': `npm install -g recli`

```shell
recli 'r.table("contacts").count()'
```

## Import scripts

RethinkDB provides for [bulk imports](https://www.rethinkdb.com/docs/importing/): you will need python and pip installed and the RethinkDB python driver.

```shell
$ pip install rethinkdb
# ...

$ cd contacts
$ rethinkdb import -f /tmp/seed-data.json --table test.contacts
no primary key specified, using default primary key when creating table
[========================================] 100% 
500 rows imported in 1 table
  Done (0 seconds)
```


