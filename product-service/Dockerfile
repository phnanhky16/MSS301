# runtime image only; jar must be compiled beforehand using Maven on
# the host. this approach avoids repeated downloads inside the
# container which were failing intermittently.
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "app.jar"]
