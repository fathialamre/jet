class RegisterRequest {
  final String phone;

  RegisterRequest({required this.phone});

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}
