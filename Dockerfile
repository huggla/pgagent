FROM huggla/alpine-official:20180921-edge as alpine

ARG PGAGENTVERSION="4.0.0"
ARG BUILDDEPS="postgresql-dev cmake gcc g++ libc-dev make boost-dev"
ARG DOWNLOAD="https://ftp.postgresql.org/pub/pgadmin/pgagent/pgAgent-$PGAGENTVERSION-Source.tar.gz"

RUN apk --no-cache add $BUILDDEPS \
 && wget $DOWNLOAD \
 && tar -xvp -f pgAgent-$PGAGENTVERSION-Source.tar.gz \
 && cd pgAgent-$PGAGENTVERSION-Source \
 && cmake -DCMAKE_INSTALL_PREFIX=/usr -DSTATIC_BUILD:BOOLEAN=FALSE \
 && make \
 && mkdir -p /pgagent/extension \
 && cp *.sql *.control sql/* /pgagent/extension/ \
 && rm /pgagent/extension/pgagent.sql \
 && cp pgagent /pgagent/
 
 FROM scratch as image
 
 COPY --from=alpine /pgagent/pgagent /usr/local/bin/
 COPY --from=alpine /pgagent/extension /usr/share/postgresql/
