# Dockerfile for user-service now builds **only a runtime image**.
# the application JAR must be created ahead of time by running
# `mvn clean package -DskipTests` in the user-service directory on
# the host machine. this avoids any network dependency during the
# Docker build, which repeatedly failed previously when Maven
# attempted to fetch artifacts inside the container.

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# copy the already-built artifact; wildcard covers snapshot names
COPY target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
