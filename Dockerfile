# Eureka Server
# Author: Jackie King
# License: Apache License 2.0

FROM openjdk:8u151-jre-slim
MAINTAINER Wenbo Wang <jackie-1685@163.com>

# The final jar file build by Maven
ARG JAR_FILE

# The environment
ENV DEFAULT_EUREKA_SERVER_PORT=8761

ENV DEFAULT_EUREKA_SERVER_SPRING_PROFILES_ACTIVE=default

ENV DEFAULT_EUREKA_SERVER_SPRING_CLOUD_CONFIG_ENABLED=false
ENV DEFAULT_EUREKA_SERVER_SPRING_CLOUD_CONFIG_URI=http://localhost:8888

#Copy the final jar file
ADD ${JAR_FILE} /eureka-server/eureka-server.jar

# Volume tmp files
VOLUME /tmp

#Make the port ${SERVER_PORT} available to the world outside this container
EXPOSE ${DEFAULT_EUREKA_SERVER_PORT}

#
WORKDIR /eureka-server

# -Djava.security.egd=file:/dev/./urandom
# Tomcat generate session id according to OS dev/random or dev/urandome
# The dev/random can cause delays during startup if entropy source that is used to initialize SecureRandom is short of entropy
# The dev/urandom is not
# . in file path is used to avoid tomcat origin bug
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "eureka-server.jar", \
	"--spring.profiles.active=${DEFAULT_EUREKA_SERVER_SPRING_PROFILES_ACTIVE}", \
	"--spring.cloud.config.enabled=${DEFAULT_EUREKA_SERVER_SPRING_CLOUD_CONFIG_ENABLED}", \
	"--spring.cloud.config.uri=${DEFAULT_EUREKA_SERVER_SPRING_CLOUD_CONFIG_URI}"]