FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy parent POM
COPY pom.xml ./pom.xml

# Copy cart-service
COPY cart-service/pom.xml ./cart-service/pom.xml
COPY cart-service/src ./cart-service/src

# Install parent POM, then build cart-service  
RUN mvn install -N -f ./pom.xml -DskipTests && \
    mvn clean package -f ./cart-service/pom.xml -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/cart-service/target/*.jar app.jar
EXPOSE 8085
ENTRYPOINT ["java", "-jar", "app.jar"]
