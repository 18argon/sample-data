# Sample data

A repo that contains publicly available data with import scripts into various databases

## Contacts

US Contacts from [Brian Dunning Sample Data](https://www.briandunning.com/sample-data/). 500 contacts for free, much more for a nominal price.

### Docker images

#### Mongo: docker/mongo

Create a derived [MongoDB docker image](https://hub.docker.com/_/mongo/) containing an initialized `test.contacts` collection.

Scripts are provided in `docker/` for:

* `./build.sh build mongo`: build the docker image
* `./build.sh run mongo`: create/start a container from the new image
* `./build.sh teardown mongo`: stop the container and remove the container/image

After `build.sh` and `run.sh`, you can connect to MongoDB on `localhost:27017` using [mongo-express](https://github.com/mongo-express/mongo-express) or, to the mongo shell in the docker container with:

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

Create a derived [Percona Server](https://www.percona.com/software/mysql-database/percona-server) [docker image](https://hub.docker.com/_/percona/) containing an initialized `test.contacts` table.

Scripts are provided in `docker/` for:

* `./build.sh build percona`: build the docker image
* `./build.sh run percona`: create/start a container from the new image
* `./build.sh teardown percona`: stop the container and remove the container/image

After build and run, you can connect to Percona Server on `localhost:3306` with `test`/`test` or `root`/`root`.

### Import scripts

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

#### MySQL: contacts/us-500.mysql.sql

1. Right click on the target schema (test?) and choose `Set as Default Schema`
1. Paste into a Query window
1. Execute

OR

1. From MySQL Workbench, Menu Server -> Data Import
1. Select Import from Self-Contained File: select `us-500.mysql.sql`
1. Default Target Schema: test
1. Click: Start Import

Refresh the target schema

