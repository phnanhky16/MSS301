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

  // Get cart (backend uses JWT to identify user, no userId in path)
  Future<void> fetchCart(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/cart-service/carts');
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

  // Add to cart (POST /carts/items - backend extracts userId from JWT)
  Future<bool> addToCart(int userId, int productId, int quantity) async {
    try {
      final response = await ApiService.post(
        '/cart-service/carts/items',
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

  // Update cart item (PUT /carts/items/{productId} - no userId in path)
  Future<bool> updateCartItem(
    int userId,
    int productId,
    int quantity,
  ) async {
    try {
      final response = await ApiService.put(
        '/cart-service/carts/items/$productId',
        {'quantity': quantity},
      );

      if (response['success'] == true) {
        // Instead of replacing the whole cart (which may reorder items),
        // update the existing item locally and adjust totals.
        if (_cart != null) {
          final idx =
              _cart!.items.indexWhere((item) => item.productId == productId);
          if (idx != -1) {
            final oldItem = _cart!.items[idx];
            final updatedItem = CartItem(
              id: oldItem.id,
              productId: oldItem.productId,
              quantity: quantity,
              product: oldItem.product,
            );
            final itemsCopy = List<CartItem>.from(_cart!.items);
            itemsCopy[idx] = updatedItem;
            final diff = quantity - oldItem.quantity;
            final priceChange = (oldItem.product?.price ?? 0) * diff.toDouble();

            _cart = Cart(
              id: _cart!.id,
              userId: _cart!.userId,
              items: itemsCopy,
              totalItems: _cart!.totalItems + diff,
              totalPrice: _cart!.totalPrice + priceChange,
            );
          } else {
            // fallback: parse full cart if item not found
            _cart = Cart.fromJson(response['data']);
          }
        } else {
          // no local cart yet; just set it
          _cart = Cart.fromJson(response['data']);
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update cart error: $e');
      return false;
    }
  }

  // Remove from cart (DELETE /carts/items/{productId} - no userId in path)
  Future<bool> removeFromCart(int userId, int productId) async {
    try {
      final response = await ApiService.delete(
        '/cart-service/carts/items/$productId',
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

  // Clear cart (DELETE /carts - no userId in path)
  Future<bool> clearCart(int userId) async {
    try {
      final response = await ApiService.delete('/cart-service/carts');
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
