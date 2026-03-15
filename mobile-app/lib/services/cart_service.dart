import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'api_service.dart';
import '../models/cart.dart';

class CartService extends ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;
  String? _lastErrorMessage;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  int get itemCount => _cart?.totalItems ?? 0;
  double get totalPrice => _cart?.totalPrice ?? 0.0;
  String? get lastErrorMessage => _lastErrorMessage;

  /// Parse backend error message from exception string
  /// Handles both ApiResponse format (400 errors) and Spring error format (500 errors)
  String _extractErrorMessage(String exceptionString) {
    try {
      // Try to extract JSON from exception string
      final startIdx = exceptionString.indexOf('{');
      final endIdx = exceptionString.lastIndexOf('}');

      if (startIdx != -1 && endIdx != -1) {
        final jsonStr = exceptionString.substring(startIdx, endIdx + 1);
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;

        // Try ApiResponse.message first (400 errors)
        if (json['message'] != null && json['message'].toString().isNotEmpty) {
          return json['message'].toString();
        }

        // Try Spring error format (500 errors)
        if (json['error'] != null && json['error'].toString().isNotEmpty) {
          String baseError = json['error'].toString();
          // If there's also a detail, include it
          if (json['status'] != null) {
            return '$baseError (Mã lỗi: ${json['status']})';
          }
          return baseError;
        }

        // Fallback: if both are empty
        return 'Lỗi máy chủ không rõ (Vui lòng thử lại sau)';
      }
    } catch (e) {
      // If parsing fails, return generic message
    }
    return 'Lỗi kết nối hoặc máy chủ không phản hồi';
  }

  // Get cart (backend uses JWT to identify user, no userId in path)
  Future<void> fetchCart(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('📦 Fetching cart from backend...');
      final response = await ApiService.get('/cart-service/carts');
      print('📱 Fetch cart response: $response');

      if (response['success'] == true) {
        print('✅ Cart fetched successfully');
        _cart = Cart.fromJson(response['data']);
        print('🛒 Cart has ${_cart?.items.length ?? 0} items');
      } else {
        print('❌ Fetch cart failed: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('❌ Fetch cart error: $e');
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        print('⚠️  Unauthorized - JWT token not set or expired');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to cart (POST /carts/items - backend extracts userId from JWT)
  Future<bool> addToCart(int userId, int productId, int quantity,
      {int maxRetries = 5}) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
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
          _lastErrorMessage = null;
          _cart = Cart.fromJson(response['data']);
          notifyListeners();
          return true;
        } else {
          final errorMsg = response['message'] ?? 'Unknown error';
          _lastErrorMessage = errorMsg;
          return false;
        }
      } catch (e) {
        retryCount++;

        // Parse error details
        final errorString = e.toString();
        final isSeviceUnavailable =
            errorString.contains('503') || errorString.contains('Connection');
        final isInternalError = errorString.contains('500');

        if ((isSeviceUnavailable || isInternalError) &&
            retryCount < maxRetries) {
          final delayMs = 300 + (200 * retryCount);
          await Future.delayed(Duration(milliseconds: delayMs));
          continue; // Retry
        }

        _lastErrorMessage = _extractErrorMessage(errorString);

        if (errorString.contains('401') ||
            errorString.contains('Unauthorized')) {
          _lastErrorMessage =
              '⚠️ Phiên đăng nhập hết hiệu lực. Vui lòng đăng nhập lại.';
        }

        return false;
      }
    }

    _lastErrorMessage =
        'Không thể thêm vào giỏ hàng sau $maxRetries lần thử. Vui lòng thử lại sau.';
    return false;
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
      return false;
    }
  }
}
