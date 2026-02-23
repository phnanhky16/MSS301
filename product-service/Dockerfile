# multi-stage build so `docker compose up --build` can compile the
# artifact automatically. we also use a shared m2cache to speed up
# dependency downloads across services.

# syntax directive for cache mounts
# syntax=docker/dockerfile:1.4

# --- build stage ----------------------------------------------------------
# the specific maven image flavour with JDK21 is not published,
# fall back to the 17 variant which works to compile any Java 17+ code.
FROM maven:3.9.0-eclipse-temurin-17 AS build
WORKDIR /app

# copy minimal files to leverage layer caching
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
