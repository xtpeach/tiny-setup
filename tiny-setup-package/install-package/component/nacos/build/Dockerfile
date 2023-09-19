# docker pull openjdk:8-jdk
FROM openjdk:8-jdk
# author
MAINTAINER xtpeach
# bin dir
COPY nacos /home/nacos
# environment
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
# start command
COPY start.sh /home/
RUN chmod u+x /home/start.sh
CMD ["bash", "/home/start.sh"]
# port
EXPOSE 8848