# Sample data

A repo that contains publicly available data with import scripts into various databases

## Contacts

US Contacts from [Brian Dunning Sample Data](https://www.briandunning.com/sample-data/). 500 contacts for free, much more for a nominal price.

### Docker images

#### ElasticSearch: docker/elasticsearch

Create a derived [ElasticSearch docker image](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) containing an initialized `contacts` index stored in a docker volume.

This involves some monkey patching to the ES start script `es-docker` since no facilities are provided to initialize ES with data. `es-docker` will contain a line `(/seed-data/data-load.sh &)` which spawns a process that sleeps for 60s, checks if the `contacts` index exists, and if not, index the contacts data.

Scripts are provided in `docker/` for:

* `./build.sh build elasticsearch`: build the docker image
* `./build.sh run elasticsearch `: create/start a container from the new image
* `./build.sh teardown elasticsearch `: stop the container and remove the container/image

After build and run, you can connect to ES using creds `elastic`/`changeme` via curl or browser.

* browser: [http://elastic:changeme@localhost:9200/contacts/_search?pretty=true&q=\*:\*](http://elastic:changeme@localhost:9200/contacts/_search?pretty=true&q=*:*)
* curl: `curl elastic:changeme@localhost:9200/contacts/_search\?pretty\=true\&q\=\*:\*`

**NOTE**: As of ES 5, [site plugins are no longer supported](https://www.elastic.co/blog/running-site-plugins-with-elasticsearch-5-0). This means that the very useful `head`, `kopf`, `marvel` plugins cannot run in ES 5; the x-pack `monitoring` replacement for `marvel` is installed but requires a kibana deployment pointing at this container to display the dashboards. 

#### Mongo: docker/mongo

Create a derived [MongoDB docker image](https://hub.docker.com/_/mongo/) containing an initialized `test.contacts` collection stored in a docker volulme.

Scripts are provided in `docker/` for:

* `./build.sh build mongo`: build the docker image
* `./build.sh run mongo`: create/start a container from the new image
* `./build.sh teardown mongo`: stop the container and remove the container/image

After build and run, you can connect to MongoDB on `localhost:27017` using [mongo-express](https://github.com/mongo-express/mongo-express) or, to the mongo shell in the docker container with:

```shell
$ docker run -it \
    --link mongo-sample-data:mongo \
    --rm mongo sh -c \
    'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/test"'
MongoDB shell version v3.4.3
connecting to: mongodb://172.17.0.2:27017/test
MongoDB server version: 3.4.3
Welcome to the MongoDB shell.

# remaining startup comments omitted...

> db.contacts.findOne()
{
        "_id" : ObjectId("58fc2073a8544985c2a8a0f4"),
        "firstName" : "James",
        "lastName" : "Butt",
        "companyName" : "Benton, John B Jr",
        "address" : "6649 N Blue Gum St",
        "city" : "New Orleans",
        "county" : "Orleans",
        "state" : "LA",
        "zip" : "70116",
        "phone1" : "504-621-8927",
        "phone2" : "504-845-1427",
        "email" : "jbutt@gmail.com",
        "website" : "http://www.bentonjohnbjr.com"
}
> exit
bye
```


#### Percona: docker/percona

Create a derived [Percona Server](https://www.percona.com/software/mysql-database/percona-server) [docker image](https://hub.docker.com/_/percona/) containing an initialized `test.contacts` table with all data stored in a docker volume.

Scripts are provided in `docker/` for:

* `./build.sh build percona`: build the docker image
* `./build.sh run percona`: create/start a container from the new image
* `./build.sh teardown percona`: stop the container and remove the container/image

After build and run, you can connect to Percona Server on `localhost:3306` with `test`/`test` or `root`/`root`.


#### RethinkDB: docker/rethink

Create a derived [RethinkDB](https://www.rethinkdb.com/) [docker image](https://hub.docker.com/_/rethinkdb/) containing an initialized `test.contacts` collection in a docker volume.

Scripts are provided in `docker/` for:

* `./build.sh build rethink`: build the docker image
* `./build.sh run rethink`: create/start a container from the new image
* `./build.sh teardown rethink`: stop the container and remove the container/image

After build and run, you can connect to the RethinkDB web ui at [http://localhost:8080/](http://localhost:8080/)

RethinkDB does not provide database initialization support. We could use RethinkDB's [bulk import support](https://www.rethinkdb.com/docs/importing/) and monkey-patch a docker-entrypoint.sh into the base image, but that requires installing python, pip, and the RethinkDB python driver increasing image size from 183MB to 256MB.

Instead, the build process creates a temp container with a mounted `/data` volume, installs required packages, and imports the contacts. Then, when building the final image, the temp container's `/data` is copied into the final image. The final image is a bit slimmer at 199MB.


### Import scripts

#### ElasticSearch: contacts/us-500.elasticsearch

```shell
$ cd contacts
$ curl -s -H "Content-Type: application/x-ndjson" \
    -XPOST "elastic:changeme@localhost:9200/_bulk" --data-binary "@us-500.elasticsearch"
{"took":96,"errors":false,"items":[{"index":{"_index":"contacts","_type":
# remaining output truncated
```

#### Mongo: contacts/us-500.mongoimport

```shell
$ cd contacts
$ mongoimport --db=test --collection=contacts --drop --file=us-500.mongoimport
2016-03-03T18:45:40.935-0600	connected to: localhost
2016-03-03T18:45:40.935-0600	dropping: test.contacts
2016-03-03T18:45:40.971-0600	imported 500 documents
```

#### Mongo: contacts/us-500.mongo.js

```shell
$ cd contacts
$ mongo test us-500.mongo.js 
MongoDB shell version v3.4.2
connecting to: mongodb://127.0.0.1:27017/test
MongoDB server version: 3.4.2
```

#### RethinkDB: contacts/us-500.json

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




#### MySQL: contacts/us-500.mysql.sql

From MySQL Workbench: 

1. Right click on the target schema (test?) and choose `Set as Default Schema`
1. Paste into a Query window
1. Execute

OR

1. Menu Server -> Data Import
1. Select Import from Self-Contained File: select `us-500.mysql.sql`
1. Default Target Schema: test
1. Click: Start Import

Refresh the target schema

