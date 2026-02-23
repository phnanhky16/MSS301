## runtime-only image; jar should be built on the host prior to
## running docker compose.  network flakiness inside the build
## container made the previous multi-stage approach unreliable.
## multi-stage Dockerfile so that `docker compose up --build` can compile
## the jar automatically instead of relying on a beforehand host build.
## the first stage builds with Maven; the second stage runs using slim JRE.

# --- build stage ----------------------------------------------------------
FROM maven:3.9.0-eclipse-temurin-17 AS build
# explicitly enable BuildKit features (cache mounts) via the syntax directive
# at top of file; this line is a no-op when not using BuildKit but required for
# the `--mount=type=cache` below.  The shebang must be at the very top.
# syntax=docker/dockerfile:1.4
WORKDIR /app

# copy project files for maven
COPY pom.xml ./
COPY src ./src

# build jar (skip tests for speed) while caching the local maven repository
# between builds; the cache volume persists between docker compose runs if
# BuildKit is enabled (DOCKER_BUILDKIT=1).  This dramatically shortens
# subsequent builds because dependencies are already present.
# clean any failed/partial downloads from cache before building; keeps
# shared m2cache healthy across services.
RUN --mount=type=cache,id=m2cache,target=/root/.m2 \
    sh -c "find /root/.m2 -name '*.lastUpdated' -delete || true" && \
    mvn clean package -DskipTests

# --- runtime stage --------------------------------------------------------
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

## create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# copy artifact from build stage
COPY --from=build /app/target/*.jar app.jar

## fix ownership and switch to non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# Expose the port
EXPOSE 8082

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8082/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
