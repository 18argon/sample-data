## Sample data

Derived database derived docker images seeded with sample data.

## Contacts

US Contacts from [Brian Dunning Sample Data](https://www.briandunning.com/sample-data/). 500 contacts for free, much more for a nominal price.

## Docker images

Docker images are built via local makefiles. See `make help` for more details.

See each docker directory's README.md for more details:

* [elasticsearch](https://github.com/stevetarver/sample-data/tree/master/docker/elasticsearch)
* [mongo](https://github.com/stevetarver/sample-data/tree/master/docker/mongo)
* [percona](https://github.com/stevetarver/sample-data/tree/master/docker/percona)
* [postgres](https://github.com/stevetarver/sample-data/tree/master/docker/postgres)
* [rethink](https://github.com/stevetarver/sample-data/tree/master/docker/rethink)

## TODO

* Make test targets wait for database to become ready
* Provide revisions on our derived image tags
