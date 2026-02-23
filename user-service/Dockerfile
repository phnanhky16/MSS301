# runtime-only Dockerfile; jar must be compiled beforehand using Maven on
# the host. this approach avoids network failures during the container
# build stage (we saw central timeouts when doing the multi-stage build).
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# copy the already-built artifact; wildcard covers snapshot names
COPY target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
