## runtime-only image; jar should be built on the host prior to
## running docker compose.  network flakiness inside the build
## container made the previous multi-stage approach unreliable.
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

## create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

## copy the previously-built artifact; wildcard covers snapshot names
## make sure to run `mvn clean package -DskipTests` in order-service
## before starting the stack.
COPY target/*.jar app.jar

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
