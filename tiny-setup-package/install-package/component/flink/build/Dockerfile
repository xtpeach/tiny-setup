# docker pull openjdk:8-jdk
FROM openjdk:8-jdk
# author
MAINTAINER xtpeach
# bin dir
COPY flink-1.17.1 /usr/local/flink-1.17.1
# environment
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    PATH=/usr/local/flink/bin:${PATH} \
    FLINK_CONF_DIR=/usr/local/flink/conf \
    FLINK_DATA_DIR=/data/flink \
    FLINK_DATA_LOG_DIR=/data/flink/datalog \
    FLINK_LOG_DIR=/data/flink/logs
# run command
RUN set -eux; \
    ln -sv /usr/local/flink-1.17.1/ /usr/local/flink; \
    mkdir -p "$FLINK_DATA_LOG_DIR" "$FLINK_DATA_DIR"  "$FLINK_LOG_DIR";
# entrypoint.sh
COPY entrypoint.sh /usr/local/flink/bin/
RUN chmod u+x /usr/local/flink/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# start command
COPY start.sh /usr/local/flink/bin/
RUN chmod u+x /usr/local/flink/bin/start.sh
CMD ["bash", "start.sh"]
# port
EXPOSE 2181 2888 3888