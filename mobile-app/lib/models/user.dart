class User {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final String? phone;
  final String role;
  final bool status;
  final String? avatarUrl;

  User({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('Parsing user from JSON: $json');

    try {
      // Handle role - can be string or enum object
      String roleValue;
      if (json['role'] is String) {
        roleValue = json['role'];
      } else if (json['role'] is Map) {
        roleValue = json['role']['name'] ?? json['role'].toString();
      } else {
        roleValue = json['role'].toString();
      }

      return User(
        id: json['id'],
        fullName: json['fullName'] ?? '',
        userName: json['userName'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'],
        role: roleValue,
        status: json['status'] ?? true,
        avatarUrl: json['avatarUrl'] ??
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400',
      );
    } catch (e) {
      print('Error parsing user: $e');
      rethrow;
    }
  }
}
