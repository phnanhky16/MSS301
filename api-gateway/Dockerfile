# runtime-only Dockerfile; build the JAR with Maven on the host
# before running `docker compose`. the multi-stage variant required
# network access and failed when central was unreachable.
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
