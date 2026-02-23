FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy parent POM to /app/pom.xml
# notification-service/pom.xml has <relativePath>../pom.xml</relativePath>
# so from /app/notification-service/, parent is at /app/pom.xml
COPY pom.xml ./pom.xml
COPY notification-service/pom.xml ./notification-service/pom.xml
COPY notification-service/src ./notification-service/src

# Install parent POM first, then build notification-service
RUN mvn install -N -f ./pom.xml -DskipTests && \
    mvn clean package -f ./notification-service/pom.xml -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/notification-service/target/*.jar app.jar
EXPOSE 8086
ENTRYPOINT ["java", "-jar", "app.jar"]

