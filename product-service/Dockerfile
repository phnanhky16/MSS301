# runtime image only; jar must be compiled beforehand using Maven on
# the host. this avoids network dependency problems observed earlier.
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "app.jar"]
