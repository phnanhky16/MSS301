import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../models/cart.dart';

class CartService extends ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  int get itemCount => _cart?.totalItems ?? 0;
  double get totalPrice => _cart?.totalPrice ?? 0.0;

  // Get cart
  Future<void> fetchCart(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/cart-service/carts/$userId');
      if (response['success'] == true) {
        _cart = Cart.fromJson(response['data']);
      }
    } catch (e) {
      print('Fetch cart error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to cart
  Future<bool> addToCart(int userId, int productId, int quantity) async {
    try {
      final response = await ApiService.post(
        '/cart-service/carts',
        {
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
        },
      );

      if (response['success'] == true) {
        _cart = Cart.fromJson(response['data']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Add to cart error: $e');
      return false;
    }
  }

  // Update cart item
  Future<bool> updateCartItem(
    int userId,
    int productId,
    int quantity,
  ) async {
    try {
      final response = await ApiService.put(
        '/cart-service/carts/$userId/items/$productId',
        {'quantity': quantity},
      );

      if (response['success'] == true) {
        _cart = Cart.fromJson(response['data']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update cart error: $e');
      return false;
    }
  }

  // Remove from cart
  Future<bool> removeFromCart(int userId, int productId) async {
    try {
      final response = await ApiService.delete(
        '/cart-service/carts/$userId/items/$productId',
      );

      if (response['success'] == true) {
        _cart = Cart.fromJson(response['data']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Remove from cart error: $e');
      return false;
    }
  }

  // Clear cart
  Future<bool> clearCart(int userId) async {
    try {
      final response = await ApiService.delete('/cart-service/carts/$userId');
      if (response['success'] == true) {
        _cart = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Clear cart error: $e');
      return false;
    }
  }
}
