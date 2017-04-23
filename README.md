# Sample data

A repo that contains publicly available data with import scripts into various databases

## Contacts

US Contacts from [Brian Dunning Sample Data](https://www.briandunning.com/sample-data/). 500 contacts for free, much more for a nominal price.

### Docker images

#### Percona

Create a derived [Percona Server](https://www.percona.com/software/mysql-database/percona-server) docker image containing an initialized `test.contacts` table.

Scripts are provided for:

* `build.sh`: build the docker image
* `run.sh`: create/start a container from the new image
* `teardown.sh`: stop the container and remove the container/image

After `build.sh` and `run.sh`, you can connect to Percona Server on `localhost:3306` with `test`/`test` or `root`/`root`.

### Import scripts

#### Mongo contacts/mongo.import

```
$ cd contacts
$ mongoimport --db=test --collection=contacts --drop --file=us-500.mongo
2016-03-03T18:45:40.935-0600	connected to: localhost
2016-03-03T18:45:40.935-0600	dropping: test.contacts
2016-03-03T18:45:40.971-0600	imported 500 documents
```

#### MySQL contacts/mysql.sql

1. Right click on the target schema (test?) and choose `Set as Default Schema`
1. Paste into a Query window
1. Execute

OR

1. From MySQL Workbench, Menu Server -> Data Import
1. Select Import from Self-Contained File: select `mysql.sql`
1. Default Target Schema: test
1. Click: Start Import

Refresh the target schema

