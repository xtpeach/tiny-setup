# docker pull openjdk:8-jdk
FROM openjdk:8-jdk
MAINTAINER xtpeach
COPY zookeeper-3.8.1-bin /home/zookeeper-3.8.1-bin
RUN mkdir -p /data/zookeeper
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENTRYPOINT ["/bin/bash", "/home/zookeeper-3.8.1-bin/bin/zkServer.sh", "start"]
EXPOSE 2181
EXPOSE 2888
EXPOSE 3888