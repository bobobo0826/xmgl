FROM frolvlad/alpine-oraclejdk8:slim
VOLUME /tmp
ADD xmgl-task-service-1.0-exec.war app.war
RUN sh -c 'touch /app.war'
ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.war" ]