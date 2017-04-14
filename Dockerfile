FROM tomcat:8.0-jre8-alpine

MAINTAINER justMiles "https://github.com/justmiles"

ENV OPENGROK_TOMCAT_BASE /usr/local/tomcat
ENV OPENGROK_WEBAPP_CONTEXT /
ENV OPENGROK_VERBOSE true
ENV OPENGROK_INSTANCE_BASE /var/opengrok
ENV OPENGROK_NON_INTERACTIVE true
ENV SRC_ROOT /src
# ENV OPENGROK_WEBAPP_CONTEXT /source
ENV OPENGROK_ENABLE_PROJECTS true
ENV REINDEX_MAX_DEPTH 2
ENV REINDEX_FILTER git\|tmp\|temp\|.*
ENV IGNORE_PATTERNS "-i *.jar -i *.so -i *.zip -i *.gz -i *.tar -i d:.git -i d:vendors -i d:log -i d:node_modules"

RUN apk update && apk add inotify-tools curl ctags git

RUN sed -i -e 's/v3\.5/edge/g' /etc/apk/repositories

RUN apk update && apk add incron

RUN curl -L https://github.com/OpenGrok/OpenGrok/releases/download/1.0/opengrok-1.0.tar.gz -o /tmp/opengrok.tar.gz 

RUN mkdir -p $OPENGROK_INSTANCE_BASE && tar -xzvf /tmp/opengrok.tar.gz -C $OPENGROK_INSTANCE_BASE --strip-components=1 && rm -rf /tmp/opengrok.tar.gz

RUN cd $OPENGROK_INSTANCE_BASE \
  && mkdir -p src data etc \
  && cd bin \
  && ./OpenGrok deploy

COPY entrypoint.sh /entrypoint

ENTRYPOINT ["/entrypoint"]

VOLUME /src

CMD ["catalina.sh run"]
