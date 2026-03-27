FROM alpine:3.20 AS builder
WORKDIR /build

COPY target ./target

RUN JAR_PATH="$(ls target/*SNAPSHOT.jar 2>/dev/null | head -n 1)"; \
        if [ -z "$JAR_PATH" ]; then \
            echo "Missing target jar. Run: mvn -pl product-service -am -DskipTests package"; \
            exit 1; \
        fi; \
        cp "$JAR_PATH" /tmp/app.jar

FROM amazoncorretto:17-alpine
WORKDIR /app
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup
COPY --from=builder /tmp/app.jar app.jar
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "app.jar"]
