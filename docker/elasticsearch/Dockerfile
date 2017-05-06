FROM docker.elastic.co/elasticsearch/elasticsearch:5.4.0

# copy seed data and a script to load it
USER root
COPY seed-data.json data-load.sh /seed-data/
RUN chown elasticsearch:elasticsearch /seed-data/*

# patch the run command to call the data load script
# NOTE: testing this on a mac will fail because sed does not translate \n correctly
USER elasticsearch
RUN sed 's/#!\/bin\/bash/#!\/bin\/bash\n\n# load seed data 60s after start\n(\/seed-data\/data-load.sh \&)/' \
        /usr/share/elasticsearch/bin/es-docker > /usr/share/elasticsearch/bin/es-docker.tmp && \
    mv -f /usr/share/elasticsearch/bin/es-docker.tmp /usr/share/elasticsearch/bin/es-docker && \
    chmod 766 /usr/share/elasticsearch/bin/es-docker && \
    rm -f /usr/share/elasticsearch/bin/es-docker.tmp
