## Elasticsearch

Create a derived [ElasticSearch docker image](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) containing an initialized `contacts` index stored in a docker volume.

After build and run, you can connect to ES using creds `elastic`/`changeme` via curl or browser.

* browser: [http://elastic:changeme@localhost:9200/contacts/_search?pretty=true&q=\*:\*](http://elastic:changeme@localhost:9200/contacts/_search?pretty=true&q=*:*)
* curl: `curl elastic:changeme@localhost:9200/contacts/_search\?pretty\=true\&q\=\*:\*`

This build monkey-patches the ES start script `es-docker` since no facilities are provided to initialize ES with data. `es-docker` will contain a line `(/seed-data/data-load.sh &)` which spawns a process that sleeps for 60s, checks if the `contacts` index exists, and if not, index the contacts data.

**NOTE**: As of ES 5, [site plugins are no longer supported](https://www.elastic.co/blog/running-site-plugins-with-elasticsearch-5-0). This means that the very useful `head`, `kopf`, `marvel` plugins cannot run in ES 5; the x-pack `monitoring` replacement for `marvel` is installed but requires a kibana deployment pointing at this container to display the dashboards. IOW: there is no web ui for this ES container.

## Connection info

| Name | Value  |
|--- |--- |
| user | elastic |
| password | changeme |
| index | contents |
| port | 5432 |


## Run a container

```bash
docker run -d --name elasticsearch-sample-data  \
    -p 9200:9200 -p 9300:9300                   \
    -e "http.host=0.0.0.0"                      \
    -e "transport.host=127.0.0.1"               \
    stevetarver/elasticsearch-sample-data:5.4
```

## Fetch data from command line

```
curl -s elastic:changeme@localhost:9200/_cat/count/contacts
curl elastic:changeme@localhost:9200/contacts/_search\?pretty\=true\&q\=\*:\*
```

## Importing data

```shell
$ curl -s -H "Content-Type: application/x-ndjson" \
    -XPOST "elastic:changeme@localhost:9200/_bulk" --data-binary "@seed-data.json"
{"took":96,"errors":false,"items":[{"index":{"_index":"contacts","_type":
# remaining output truncated
```

