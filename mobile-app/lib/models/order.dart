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
    // Support both flat and nested product object
    final product = json['product'] as Map<String, dynamic>?;
    String? imageUrl;
    if (product != null) {
      final urls = product['imageUrls'];
      if (urls is List && urls.isNotEmpty) {
        imageUrl = urls[0] as String?;
      } else {
        imageUrl = product['imageUrl'] as String?;
      }
    }

    return OrderItem(
      id: json['id'] as int,
      productId: (json['productId'] ?? product?['id']) as int,
      productName:
          (json['productName'] ?? product?['name'] ?? 'Unknown') as String,
      productImageUrl: imageUrl ?? json['productImageUrl'] as String?,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Order {
  final int id;
  final String status; // PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String? shippingAddress;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
    this.shippingAddress,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return Order(
      id: json['id'] as int,
      status: (json['status'] as String? ?? 'PENDING').toUpperCase(),
      totalAmount: (json['totalAmount'] ?? json['total'] ?? 0 as num).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      items: rawItems
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shippingAddress'] as String?,
    );
  }
}
