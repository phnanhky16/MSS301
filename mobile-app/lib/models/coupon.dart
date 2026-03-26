class Coupon {
  final int id;
  final String code;
  final bool active;
  final double discountValue;
  final String discountType; // PERCENT or FIXED
  final DateTime? expiresAt;
  final int? maxRedemptions;
  final int timesRedeemed;

  Coupon({
    required this.id,
    required this.code,
    required this.active,
    required this.discountValue,
    required this.discountType,
    this.expiresAt,
    this.maxRedemptions,
    required this.timesRedeemed,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      active: json['active'] as bool? ?? false,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      discountType: json['discountType'] as String? ?? 'PERCENT',
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
      maxRedemptions: json['maxRedemptions'] as int?,
      timesRedeemed: json['timesRedeemed'] as int? ?? 0,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isUsable {
    if (!active) return false;
    if (isExpired) return false;
    if (maxRedemptions != null && timesRedeemed >= maxRedemptions!) {
      return false;
    }
    return true;
  }

  // Calculate discount amount based on total
  double calculateDiscount(double total) {
    if (!isUsable) return 0;
    if (discountType == 'PERCENT') {
      return total * (discountValue / 100);
    } else {
      return discountValue;
    }
  }
}
