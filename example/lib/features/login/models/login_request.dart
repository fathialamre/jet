class LoginRequest {
  final String phone;
  final String password;

  const LoginRequest({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
    };
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      phone: json['phone'] as String,
      password: json['password'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        other.phone == phone &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(phone, password);

  @override
  String toString() => 'LoginRequest(phone: $phone, password: [HIDDEN])';
}
