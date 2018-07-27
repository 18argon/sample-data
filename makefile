# global operations for docker images

TARGETS = 	docker/elasticsearch \
			docker/mongo \
			docker/percona \
			docker/postgres \
			docker/rethink

.PHONY: all
all:
	@for dir in $(TARGETS); do \
		$(MAKE) -C $$dir all; \
	done

.PHONY: clean
clean:
	@for dir in $(TARGETS); do \
		$(MAKE) -C $$dir clean; \
	done
