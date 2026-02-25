import 'product.dart';

class CartItem {
  final int id;
  final int productId;
  final int quantity;
  final Product? product;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      product: json['product'] != null 
          ? Product.fromJson(json['product']) 
          : null,
    );
  }

  double get subtotal => product != null ? product!.price * quantity : 0.0;
}

class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;
  final int totalItems;
  final double totalPrice;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalItems,
    required this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalItems: json['totalItems'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
}
