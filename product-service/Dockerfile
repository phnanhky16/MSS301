FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml ./
COPY src ./src

RUN --mount=type=cache,id=m2cache,target=/root/.m2 \
	sh -c "find /root/.m2 -name '*.lastUpdated' -delete || true" && \
	mvn clean package -DskipTests

# --- runtime stage --------------------------------------------------------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8083
ENTRYPOINT ["java", "-jar", "app.jar"]
