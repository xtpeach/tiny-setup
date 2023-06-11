# docker pull openjdk:8-jdk-alpine
FROM openjdk:8-jdk-alpine
MAINTAINER xtpeach
ADD app/{project.name}-{project.version}.jar app.jar
RUN mkdir -p /home/logs/oom/{project.name}
ENV JAVA_OPTS=${JAVA_OPTS} \
    JAR_OPTS=${JAR_OPTS} \
    LANG=C.UTF-8 LC_ALL=C.UTF-8
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar /app.jar $JAR_OPTS" ]
EXPOSE 38761