## Mongo

Create a derived [MongoDB docker image](https://hub.docker.com/_/mongo/) containing an initialized `test.contacts` collection stored in a docker volulme.

See `make help` for build details.

After build and run, you can connect to MongoDB on `localhost:27017` using [mongo-express](https://github.com/mongo-express/mongo-express) or, to the mongo shell in the docker container with:

```shell
$ docker run --rm -it \
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

## Connection info

| Name | Value  |
|--- |--- |
| user | |
| password | |
| database | test |
| port | 27017 |

## Run a container

```bash
docker run -d --name mongo-sample-data \
    -p 27017:27017 \
    stevetarver/mongo-sample-data:3.4
```

## Fetch data from command line

```bash
docker exec -it mongo-sample-data \
    mongo test --quiet --eval 'db.contacts.count();'
```

## Importing data

### us-500.mongoimport

```shell
$ mongoimport --db=test --collection=contacts --drop --file=seed-data.mongoimport
2016-03-03T18:45:40.935-0600	connected to: localhost
2016-03-03T18:45:40.935-0600	dropping: test.contacts
2016-03-03T18:45:40.971-0600	imported 500 documents
```

#### us-500.mongo.js

```shell
$ mongo test seed-data.js 
MongoDB shell version v3.4.2
connecting to: mongodb://127.0.0.1:27017/test
MongoDB server version: 3.4.2
```
