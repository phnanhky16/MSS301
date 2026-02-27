class User {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final String? phone;
  final String role;
  final bool status;

  User({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
    );
  }
}
