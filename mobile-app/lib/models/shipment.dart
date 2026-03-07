class Shipment {
  final int shipId;
  final String street;
  final String ward;
  final String district;
  final String city;
  final int userId;
  final bool status;
  final String? note;

  Shipment({
    required this.shipId,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    required this.userId,
    required this.status,
    this.note,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      shipId: json['shipId'] as int,
      street: json['street'] as String? ?? '',
      ward: json['ward'] as String? ?? '',
      district: json['district'] as String? ?? '',
      city: json['city'] as String? ?? '',
      userId: json['userId'] as int,
      status: json['status'] as bool? ?? false,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'shipId': shipId,
        'street': street,
        'ward': ward,
        'district': district,
        'city': city,
        'userId': userId,
        'status': status,
        if (note != null) 'note': note,
      };

  String get fullAddress => '$street, $ward, $district, $city';
}
