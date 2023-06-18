# docker pull openjdk:8-jdk
FROM openjdk:8-jdk
# author
MAINTAINER xtpeach
# bin dir
COPY kafka_2.13-3.4.1 /usr/local/kafka_2.13-3.4.1
# environment
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    PATH=/usr/local/kafka/bin:${PATH} \
    KAFKA_CONF_DIR=/usr/local/kafka/conf \
    KAFKA_DATA_DIR=/data/kafka
# run command
RUN set -eux; \
    ln -sv /usr/local/kafka_2.13-3.4.1/ /usr/local/kafka; \
    mkdir -p "$KAFKA_CONF_DIR" "$KAFKA_DATA_DIR";
# entrypoint.sh
COPY entrypoint.sh /usr/local/kafka/bin/
RUN chmod u+x /usr/local/kafka/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# start command
COPY start.sh /usr/local/kafka/bin/
RUN chmod u+x /usr/local/kafka/bin/start.sh
CMD ["start.sh"]
# port
EXPOSE 9092 9093