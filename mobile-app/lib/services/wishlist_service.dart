import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../models/product.dart';

class WishlistService extends ChangeNotifier {
  List<Product> _products = [];
  Set<int> _productIds = {};
  bool _isLoading = false;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  int get count => _products.length;

  bool isWishlisted(int productId) => _productIds.contains(productId);

  Future<void> fetchWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/user-service/wishlist');

      if (response['status'] == 200 && response['data'] != null) {
        final List<dynamic> data = response['data'];
        _products = data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
        _productIds = _products.map((p) => p.id).toSet();
      }
    } catch (e) {
      print('Fetch wishlist error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToWishlist(Product product) async {
    // Optimistic update
    if (!_productIds.contains(product.id)) {
      _products.add(product);
      _productIds.add(product.id);
      notifyListeners();
    }

    try {
      final response = await ApiService.post(
        '/user-service/wishlist/${product.id}',
        {},
      );

      if (response['status'] == 200 || response['status'] == 201) {
        return true;
      }

      // Rollback on failure
      _products.removeWhere((p) => p.id == product.id);
      _productIds.remove(product.id);
      notifyListeners();
      return false;
    } catch (e) {
      print('Add to wishlist error: $e');
      // Rollback
      _products.removeWhere((p) => p.id == product.id);
      _productIds.remove(product.id);
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFromWishlist(int productId) async {
    // Optimistic update
    final removed = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => _products.first,
    );
    final wasPresent = _productIds.contains(productId);
    if (wasPresent) {
      _products.removeWhere((p) => p.id == productId);
      _productIds.remove(productId);
      notifyListeners();
    }

    try {
      final response = await ApiService.delete(
        '/user-service/wishlist/$productId',
      );

      // 204 No Content = success; the body may be empty
      if (response['status'] == 204 || response['status'] == 200) {
        return true;
      }

      // Rollback on failure
      if (wasPresent) {
        _products.add(removed);
        _productIds.add(productId);
        notifyListeners();
      }
      return false;
    } catch (e) {
      print('Remove from wishlist error: $e');
      // Rollback
      if (wasPresent) {
        _products.add(removed);
        _productIds.add(productId);
        notifyListeners();
      }
      return false;
    }
  }

  Future<void> toggleWishlist(Product product) async {
    if (isWishlisted(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }
}
