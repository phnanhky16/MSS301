import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../models/order.dart';

class OrderService extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/order-service/orders');

      // Support { data: [...] }, { result: [...] }, or raw list
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

      // Sort newest first
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _error = e.toString();
      print('Fetch orders error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  Future<bool> cancelOrder(int orderId) async {
    try {
      final response =
          await ApiService.put('/order-service/orders/$orderId/cancel', {});
      final status = response['status'] as int?;
      final success = response['success'] == true ||
          status == 200 ||
          status == 204;
      if (success) {
        final idx = _orders.indexWhere((o) => o.id == orderId);
        if (idx != -1) {
          // rebuild with CANCELLED status
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
