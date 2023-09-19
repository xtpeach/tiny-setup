# docker pull openjdk:8-jdk
FROM openjdk:8-jdk
# author
MAINTAINER xtpeach
# bin dir
COPY zookeeper-3.8.1-bin /usr/local/zookeeper-3.8.1-bin
# environment
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    PATH=/usr/local/zookeeper/bin:${PATH} \
    ZOO_CONF_DIR=/usr/local/zookeeper/conf \
    ZOO_DATA_DIR=/data/zookeeper \
    ZOO_DATA_LOG_DIR=/data/zookeeper/datalog \
    ZOO_LOG_DIR=/data/zookeeper/logs
# run command
RUN set -eux; \
    ln -sv /usr/local/zookeeper-3.8.1-bin/ /usr/local/zookeeper; \
    mkdir -p "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR"  "$ZOO_LOG_DIR";
# entrypoint.sh
COPY entrypoint.sh /usr/local/zookeeper/bin/
RUN chmod u+x /usr/local/zookeeper/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# start command
COPY start.sh /usr/local/zookeeper/bin/
RUN chmod u+x /usr/local/zookeeper/bin/start.sh
CMD ["bash", "start.sh"]
# port
EXPOSE 2181 2888 3888