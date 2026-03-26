class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? productImageUrl;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Backend trả unitPrice (Java BigDecimal), fallback sang price nếu có
    final rawPrice = json['unitPrice'] ?? json['price'] ?? json['subtotal'] ?? 0;
    final price = (rawPrice is num)
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice.toString()) ?? 0.0;

    // productId: backend trả Long, Dart parse thành int
    final rawProductId = json['productId'];
    final productId = (rawProductId is int)
        ? rawProductId
        : int.tryParse(rawProductId.toString()) ?? 0;

    // id: backend trả Long
    final rawId = json['id'];
    final id = (rawId is int) ? rawId : int.tryParse(rawId.toString()) ?? 0;

    // quantity
    final rawQty = json['quantity'];
    final quantity =
        (rawQty is int) ? rawQty : int.tryParse(rawQty.toString()) ?? 0;

    return OrderItem(
      id: id,
      productId: productId,
      productName:
          (json['productName'] ?? json['name'] ?? 'Unknown') as String,
      productImageUrl: json['productImageUrl'] as String?,
      quantity: quantity,
      price: price,
    );
  }
}

class Order {
  final int id;
  final String orderNumber;
  final String status; // PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String? shippingAddress;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
    this.shippingAddress,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];

    // id: backend trả Long
    final rawId = json['id'];
    final id = (rawId is int) ? rawId : int.tryParse(rawId.toString()) ?? 0;

    // totalAmount: backend trả BigDecimal — JSON có thể là num hoặc String
    final rawTotal = json['totalAmount'] ?? json['total'] ?? 0;
    final totalAmount = (rawTotal is num)
        ? rawTotal.toDouble()
        : double.tryParse(rawTotal.toString()) ?? 0.0;

    // status: backend trả enum OrderStatus dạng String
    final rawStatus = json['status'];
    final status =
        (rawStatus != null ? rawStatus.toString() : 'PENDING').toUpperCase();

    return Order(
      id: id,
      orderNumber: json['orderNumber']?.toString() ?? id.toString(),
      status: status,
      totalAmount: totalAmount,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      items: rawItems
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shippingAddress'] as String?,
    );
  }
}
