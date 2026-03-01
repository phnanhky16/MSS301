# Hướng Dẫn Khởi Động Services Sau Khi Update

## ✅ Những gì đã thêm:

### Inventory Service:

1. **StoreInventoryRepository**: Thêm method `findAllProductIdsWithStock()` - Lấy tất cả product IDs có tồn kho
2. **StoreInventoryService**: Thêm method `getAllProductIdsWithStock()`
3. **StoreInventoryController**: Thêm endpoint `GET /api/stores/products-with-stock`

### Product Service:

1. **InventoryServiceClient**: Thêm method `getAllProductIdsWithStock()` để gọi sang Inventory Service
2. **ProductService**: Thêm method `listProductsSortedByStock()` - Sắp xếp sản phẩm theo tồn kho
3. **ProductController**: Thêm endpoint `GET /products/sorted-by-stock`

## 📋 Các bước khởi động lại services:

### Bước 1: Khởi động Docker Desktop

```powershell
# Tìm và mở Docker Desktop từ Start Menu
# Hoặc chạy lệnh:
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Đợi Docker Desktop khởi động hoàn tất (icon Docker màu xanh trong system tray)
```

### Bước 2: Kiểm tra Docker đã sẵn sàng

```powershell
docker ps
```

### Bước 3: Restart các services (chọn 1 trong 2 cách)

**Cách 1: Restart từ docker-compose**

```powershell
cd C:\Users\Admin\FPT\MSS\MSS301-BE\docker
docker-compose restart inventory-service product-service
```

**Cách 2: Restart trực tiếp containers**

```powershell
docker restart inventory-service product-service
```

### Bước 4: Kiểm tra logs để đảm bảo services khởi động thành công

```powershell
# Kiểm tra Inventory Service
docker logs inventory-service --tail 50

# Kiểm tra Product Service
docker logs product-service --tail 50
```

## 🧪 Test API mới:

### 1. Test Inventory Service - Lấy danh sách product IDs có tồn kho:

```powershell
curl http://localhost:8084/api/stores/products-with-stock
```

**Kết quả mong đợi:**

```json
{
  "status": 200,
  "message": "Found X products with stock",
  "data": [1, 2, 5, 7, 10],
  "timestamp": "2026-02-28T..."
}
```

### 2. Test Product Service - Lấy sản phẩm sắp xếp theo tồn kho:

**Qua API Gateway (port 8080):**

```powershell
curl "http://localhost:8080/api/products/sorted-by-stock?page=0&size=10"
```

**Trực tiếp Product Service (port 8083):**

```powershell
curl "http://localhost:8083/products/sorted-by-stock?page=0&size=10"
```

**Với filters:**

```powershell
# Filter theo category
curl "http://localhost:8080/api/products/sorted-by-stock?categoryId=1&page=0&size=10"

# Filter theo brand
curl "http://localhost:8080/api/products/sorted-by-stock?brandId=2&page=0&size=10"

# Filter theo keyword
curl "http://localhost:8080/api/products/sorted-by-stock?keyword=toy&page=0&size=10"

# Hiển thị tất cả sản phẩm kể cả INACTIVE
curl "http://localhost:8080/api/products/sorted-by-stock?status=ALL&page=0&size=10"
```

**Kết quả mong đợi:**

```json
{
  "status": 200,
  "message": "Products retrieved and sorted by stock availability",
  "data": {
    "content": [
      // Sản phẩm có tồn kho sẽ hiển thị trước
      {
        "id": 1,
        "name": "Product A",
        "price": 100.00,
        ...
      },
      {
        "id": 5,
        "name": "Product B",
        "price": 150.00,
        ...
      },
      // Sản phẩm không có tồn kho hiển thị sau
      {
        "id": 3,
        "name": "Product C",
        "price": 200.00,
        ...
      }
    ],
    "pageable": {...},
    "totalElements": 50,
    "totalPages": 5,
    "size": 10,
    "number": 0
  },
  "timestamp": "2026-02-28T..."
}
```

## 📊 Swagger UI:

Sau khi services khởi động, có thể test qua Swagger:

- **Inventory Service**: http://localhost:8084/swagger-ui.html
  - Tìm endpoint: `GET /api/stores/products-with-stock`

- **Product Service**: http://localhost:8083/swagger-ui.html
  - Tìm endpoint: `GET /products/sorted-by-stock`

- **API Gateway**: http://localhost:8080/swagger-ui.html
  - Tìm endpoint: `GET /api/products/sorted-by-stock`

## 🔍 Cách hoạt động:

1. **Product Service** gọi sang **Inventory Service** để lấy danh sách product IDs có tồn kho (quantity > 0)
2. **Product Service** lấy tất cả sản phẩm theo filters
3. Sắp xếp sản phẩm:
   - **Có tồn kho**: Hiển thị trước
   - **Không có tồn kho**: Hiển thị sau
4. Trả về kết quả đã phân trang

## ⚠️ Lưu ý quan trọng:

- Nếu **Inventory Service** không khả dụng, API vẫn hoạt động nhưng không sắp xếp theo tồn kho (fallback)
- Sản phẩm được coi là "có tồn kho" nếu có `quantity > 0` trong **bất kỳ cửa hàng nào**
- API hỗ trợ đầy đủ filters: keyword, categoryId, brandId, status
- API hỗ trợ pagination: page, size, sort

## 🎯 So sánh 2 endpoints:

### `/products` (API cũ):

- Sắp xếp theo ID hoặc tiêu chí được chỉ định
- Không quan tâm đến tồn kho

### `/products/sorted-by-stock` (API mới):

- **Ưu tiên hiển thị sản phẩm có tồn kho trước**
- Sau đó mới đến sản phẩm không có tồn kho
- Vẫn hỗ trợ đầy đủ filters như API cũ

---

**Build Status**: ✅ Success
**Services Updated**: `inventory-service`, `product-service`
**Date**: 2026-02-28
