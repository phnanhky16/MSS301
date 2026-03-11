import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/order.dart';

class OrderService extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Lấy userId từ SharedPreferences (được lưu khi đăng nhập) ──────────────
  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // ── Fetch tất cả đơn hàng của user hiện tại ───────────────────────────────
  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await _getUserId();
      if (userId == null) {
        _error = 'User not logged in';
        return;
      }

      // GET /orders/user/{userId} — chỉ lấy đơn của user hiện tại
      final response =
          await ApiService.get('/order-service/orders/user/$userId');

      // Backend trả { data: [...] } hoặc { result: [...] } hoặc raw list
      List<dynamic> rawList = [];
      if (response['data'] is List) {
        rawList = response['data'] as List;
      } else if (response['result'] is List) {
        rawList = response['result'] as List;
      } else if (response is List) {
        rawList = response as List;
      }

      _orders = rawList
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();

      // Sắp xếp mới nhất lên đầu
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = e.toString();
      print('Fetch orders error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Fetch đơn hàng theo status (lọc thêm theo userId ở client) ───────────
  Future<List<Order>> fetchOrdersByStatus(String status) async {
    try {
      final userId = await _getUserId();
      // GET /orders/status/{status}
      final response = await ApiService.get(
          '/order-service/orders/status/${status.toUpperCase()}');

      List<dynamic> rawList = [];
      if (response['data'] is List) {
        rawList = response['data'] as List;
      } else if (response['result'] is List) {
        rawList = response['result'] as List;
      } else if (response is List) {
        rawList = response as List;
      }

      final allByStatus = rawList
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();

      // Lọc thêm theo userId của người dùng hiện tại nếu có
      if (userId != null) {
        return allByStatus
            .where((o) => _orders.any((local) => local.id == o.id))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      return allByStatus;
    } catch (e) {
      print('Fetch orders by status error: $e');
      return [];
    }
  }

  // ── Fetch chi tiết 1 đơn hàng ─────────────────────────────────────────────
  Future<Order?> fetchOrderDetail(int orderId) async {
    try {
      final response = await ApiService.get('/order-service/orders/$orderId');
      final data = response['data'] ?? response['result'] ?? response;
      if (data is Map<String, dynamic>) {
        return Order.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Fetch order detail error: $e');
      return null;
    }
  }

  // ── Huỷ đơn hàng (PATCH /{id}/cancel) ────────────────────────────────────
  Future<bool> cancelOrder(int orderId) async {
    try {
      // Backend dùng PATCH /orders/{id}/cancel
      final response = await ApiService.patch(
          '/order-service/orders/$orderId/cancel', {});
      final status = response['status'] as int?;
      final success = response['success'] == true ||
          status == 200 ||
          status == 204;
      if (success) {
        final idx = _orders.indexWhere((o) => o.id == orderId);
        if (idx != -1) {
          final old = _orders[idx];
          _orders[idx] = Order(
            id: old.id,
            status: 'CANCELLED',
            totalAmount: old.totalAmount,
            createdAt: old.createdAt,
            items: old.items,
            shippingAddress: old.shippingAddress,
          );
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Cancel order error: $e');
      return false;
    }
  }
}
