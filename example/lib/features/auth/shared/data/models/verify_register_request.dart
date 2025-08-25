class VerifyRegisterRequest {
  final String phone;
  final String otp;

  VerifyRegisterRequest({
    required this.phone,
    required this.otp,
  });

  factory VerifyRegisterRequest.fromJson(Map<String, dynamic> json) {
    return VerifyRegisterRequest(
      phone: json['phone'] as String,
      otp: json['otp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
    };
  }
}
