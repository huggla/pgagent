ARG TAG="20190517"

FROM huggla/alpine as alpine

ARG PGAGENTVERSION="4.0.0"
ARG BUILDDEPS="postgresql-dev cmake gcc g++ libc-dev make boost-dev ssl_client wget"
ARG DOWNLOAD="https://ftp.postgresql.org/pub/pgadmin/pgagent/pgAgent-$PGAGENTVERSION-Source.tar.gz"

RUN apk add $BUILDDEPS \
 && wget $DOWNLOAD \
 && tar -xvp -f pgAgent-$PGAGENTVERSION-Source.tar.gz \
 && cd pgAgent-$PGAGENTVERSION-Source \
 && cmake -DCMAKE_INSTALL_PREFIX=/usr -DSTATIC_BUILD:BOOLEAN=FALSE \
 && make \
 && mkdir -p /pgagent/usr/share/postgresql/extension /pgagent/usr/bin \
 && cp *.sql *.control sql/* /pgagent/usr/share/postgresql/extension/ \
 && cp pgagent /pgagent/usr/bin/
 
 FROM huggla/busybox:$TAG as image
 
 COPY --from=alpine /pgagent /app
