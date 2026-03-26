class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final int stock;
  final String? imageUrl;
  final List<String> imageUrls;
  final String? categoryName;
  final String? brandName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.stock,
    this.imageUrl,
    this.imageUrls = const [],
    this.categoryName,
    this.brandName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle backend response format
    List<String> imageUrls = [];
    if (json['imageUrls'] != null && json['imageUrls'] is List) {
      imageUrls =
          List<String>.from((json['imageUrls'] as List).whereType<String>());
    }

    String? imageUrl;
    if (imageUrls.isNotEmpty) {
      imageUrl = imageUrls[0];
    } else if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl'];
    }

    String? categoryName;
    if (json['category'] != null && json['category'] is Map) {
      categoryName = json['category']['name'];
    } else if (json['categoryName'] != null) {
      categoryName = json['categoryName'];
    }

    String? brandName;
    if (json['brand'] != null && json['brand'] is Map) {
      brandName = json['brand']['name'];
    } else if (json['brandName'] != null) {
      brandName = json['brandName'];
    }

    int stock = 0;
    if (json['totalStock'] != null) {
      stock = json['totalStock'];
    } else if (json['stock'] != null) {
      stock = json['stock'];
    }

    final rawPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    final double computedEffectivePrice = (json['effectivePrice'] as num?)?.toDouble() ?? rawPrice;

    return Product(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: computedEffectivePrice,
      originalPrice: rawPrice > computedEffectivePrice ? rawPrice : null,
      stock: stock,
      imageUrl: imageUrl,
      imageUrls: imageUrls,
      categoryName: categoryName,
      brandName: brandName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'stock': stock,
      'imageUrl': imageUrl,
      'categoryName': categoryName,
      'brandName': brandName,
    };
  }
}
