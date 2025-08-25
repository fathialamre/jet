class RegisterResponse {
  final String phone;
  final int ttl;
  final String otp;

  RegisterResponse({
    required this.phone,
    required this.ttl,
    required this.otp,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      phone: json['phone'] as String,
      ttl: json['ttl'] as int,
      otp: json['otp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'ttl': ttl,
      'otp': otp,
    };
  }
}
