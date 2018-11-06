ARG TAG="20181106-edge"

FROM huggla/alpine-official:$TAG as alpine

ARG PGAGENTVERSION="4.0.0"
ARG BUILDDEPS="postgresql-dev cmake gcc g++ libc-dev make boost-dev"
ARG DOWNLOAD="https://ftp.postgresql.org/pub/pgadmin/pgagent/pgAgent-$PGAGENTVERSION-Source.tar.gz"

RUN apk --no-cache add $BUILDDEPS \
 && wget $DOWNLOAD \
 && tar -xvp -f pgAgent-$PGAGENTVERSION-Source.tar.gz \
 && cd pgAgent-$PGAGENTVERSION-Source \
 && cmake -DCMAKE_INSTALL_PREFIX=/usr -DSTATIC_BUILD:BOOLEAN=FALSE \
 && make \
 && mkdir -p /pgagent/usr/share/postgresql/extension /pgagent/usr/local/bin \
 && cp *.sql *.control sql/* /pgagent/usr/share/postgresql/extension/ \
 && rm /pgagent/usr/share/postgresql/extension/pgagent.sql \
 && cp pgagent /pgagent/usr/local/bin/
 
 FROM scratch as image
 
 COPY --from=alpine /pgagent /pgagent
