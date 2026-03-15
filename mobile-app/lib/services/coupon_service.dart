import 'api_service.dart';
import '../models/coupon.dart';

class CouponService {
  // Get coupon by code
  static Future<Coupon?> getCouponByCode(String code) async {
    try {
      final response = await ApiService.get('/order-service/coupons/$code');

      final data = response['data'] ?? response['result'] ?? response;
      if (data is Map<String, dynamic>) {
        return Coupon.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Get coupon error: $e');
      return null;
    }
  }

  // Validate coupon
  static Future<bool> validateCoupon(String code) async {
    try {
      final coupon = await getCouponByCode(code);
      if (coupon == null) {
        return false;
      }
      return coupon.isUsable;
    } catch (e) {
      print('Validate coupon error: $e');
      return false;
    }
  }
}
