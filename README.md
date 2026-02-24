# MSS301 Microservices Architecture

## Architecture Overview

This project implements a microservices architecture for a Kids Store Management System.

### Services:

1. **api-gateway** (Port 8080) - API Gateway with Spring Cloud Gateway
2. **user-service** (Port 8081) - User and Shipment management
3. **order-service** (Port 8082) - Order, OrderItem, Payment, Coupon management
4. **product-service** (Port 8083) - Product, Category, Brand, ProductImage, ProductPackage, Package management
5. **inventory-service** (Port 8084) - Warehouse and Store management
6. **cart-service** (Port 8085) - Shopping Cart and CartItem management
7. **review-service** (Port 8086) - Product Review management

### Technology Stack:
- Spring Boot 4.0.2
- Spring Cloud 2025.1.0
- Java 21
- Consul for Service Discovery
- PostgreSQL/MySQL for Database
- Maven for Build Management

### Prerequisites:
- Java 21
- Maven 3.8+
- Consul running on localhost:8500

### Building & Running with Docker

The Dockerfiles in this repo **no longer compile the projects**; they
expect that a JAR has been produced by Maven on the host.  This change
prevents intermittent network failures during image build (containers
cannot reliably reach Maven Central), and makes the Docker images much
smaller and faster to rebuild.

Before you start the containers you must build each service once:

```powershell
cd api-gateway      && mvn clean package -DskipTests
cd user-service     && mvn clean package -DskipTests
cd order-service    && mvn clean package -DskipTests
cd product-service  && mvn clean package -DskipTests
cd inventory-service&& mvn clean package -DskipTests
cd cart-service     && mvn clean package -DskipTests
cd review-service   && mvn clean package -DskipTests
```

After the JAR files exist in the `target/` directories you can start the
whole stack with Docker Compose:

```powershell
$Env:DOCKER_BUILDKIT=1   # optional, for cache mounts when rebuilding later
docker compose -f docker\docker-compose.yml up -d --build
```

### Coupon support (order-service)

Order service now contains a first‑class coupon domain. you can:

* **create or update** coupons:
    ```http
    POST /api/coupons
    Content-Type: application/json

    {
        "code":"SPRING10",
        "discountType":"PERCENT",
        "discountValue":10,
        "expiresAt":"2026-12-31T23:59:59",
        "maxRedemptions":100,
        "active":true
    }
    ```
* **fetch coupon details:** `GET /api/coupons/{code}`
* **list all coupons:** `GET /api/coupons`
* **modify existing coupon:** `PUT /api/coupons/{code}` (body same as create)
* **delete coupon:** `DELETE /api/coupons/{code}`

When creating an order you may include `couponCode` in the request body;
the service validates the coupon, applies the discount to the total
amount, and records both the code and discount amount on the order.

The gateway routes `/api/coupons/**` through to order-service as well.

If you change code you only need to rebuild the affected service(s) with
Maven and then re-run `docker compose` – the images will pick up the
updated JARs without having to re-download dependencies.

### API Gateway Endpoints:

- `/api/users/**` -> User Service
- `/api/orders/**` -> Order Service
- `/api/products/**` -> Product Service
- `/api/inventory/**` -> Inventory Service
- `/api/cart/**` -> Cart Service
- `/api/reviews/**` -> Review Service

### Service Discovery:

All services register with Consul at `localhost:8500`
if any service's pom.xml, simply add (no version needed — managed by the root POM):
<dependency>
    <groupId>com.kidfavor</groupId>
    <artifactId>common-library</artifactId>
</dependency>