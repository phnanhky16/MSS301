# MSS301 Microservices Architecture

## Architecture Overview

This project implements a microservices architecture for a Kids Store Management System.

### Services:

1. **api-gateway** (Port 8080) - API Gateway with Spring Cloud Gateway
2. **product-service** (Port 8081) - Product, Category, Brand, ProductImage, ProductPackage, Package management
3. **user-service** (Port 8082) - User and Shipment management
4. **order-service** (Port 8083) - Order, OrderItem, Payment, Coupon management
5. **inventory-service** (Port 8084) - Warehouse and Store management
6. **cart-service** (Port 8085) - Shopping Cart and CartItem management
7. **review-service** (Port 8086) - Product Review management
8. **notification-service** (Port 8087) - Notification management

### Technology Stack:
- Spring Boot 3.2.5
- Spring Cloud 2023.0.0
- Java 17
- Consul for Service Discovery
- PostgreSQL/MySQL for Database
- Maven for Build Management

### Prerequisites:
- Java 17
- Maven 3.9+
- Docker & Docker Compose
- Consul running on localhost:8500 (included in docker-compose)

### Building & Running with Docker

The Dockerfiles use **multi-stage builds** that compile the projects inside the container.
This approach uses Maven cache and builds everything in a consistent environment.

**Build all services:**

```bash
docker-compose -f docker/docker-compose.yml build
```

**Start all containers:**

```bash
docker-compose -f docker/docker-compose.yml up -d
```

**Stop all containers:**

```bash
docker-compose -f docker/docker-compose.yml down
```

**View logs:**

```bash
docker-compose -f docker/docker-compose.yml logs -f [service-name]
```

**Rebuild specific service:**

```bash
docker-compose -f docker/docker-compose.yml build [service-name]
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

- `/product-service/**` -> Product Service (Port 8081)
- `/user-service/**` -> User Service (Port 8082)
- `/order-service/**` -> Order Service (Port 8083)
- `/inventory-service/**` -> Inventory Service (Port 8084)
- `/cart-service/**` -> Cart Service (Port 8085)
- `/review-service/**` -> Review Service (Port 8086)
- `/notification-service/**` -> Notification Service (Port 8087)

### Service Discovery:

All services register with Consul at `localhost:8500`
if any service's pom.xml, simply add (no version needed — managed by the root POM):
<dependency>
    <groupId>com.kidfavor</groupId>
    <artifactId>common-library</artifactId>
</dependency>