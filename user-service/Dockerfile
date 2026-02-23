# multi-stage Dockerfile so `docker compose up --build` can do everything
# in one step. the first stage uses a Maven image to compile the project and
# produce the JAR; the second stage is a slim runtime image that copies the
# artifact from the build stage. building inside the container may still
# suffer occasional network hiccups, but it's the only way to make compose
# fully self‑contained as requested.

# --- build stage ----------------------------------------------------------
FROM maven:3.9.0-eclipse-temurin-17 AS build
WORKDIR /app

# copy only the files needed for Maven to compute the dependency graph first
# (this layer is cached unless pom.xml changes)
COPY pom.xml ./
COPY src ./src

# syntax=docker/dockerfile:1.4
# clean stale lastUpdated files from shared cache so broken downloads don't
# poison the build for other services.
RUN --mount=type=cache,id=m2cache,target=/root/.m2 \
	sh -c "find /root/.m2 -name '*.lastUpdated' -delete || true" && \
	mvn clean package -DskipTests

# --- runtime stage --------------------------------------------------------
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# copy jar produced by build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
