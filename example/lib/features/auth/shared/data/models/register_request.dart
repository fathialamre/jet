class RegisterRequest {
  final String phone;
  final String name;
  final String password;
  final String? fcmToken;
  final String passwordConfirmation;

  RegisterRequest({
    required this.phone,
    required this.name,
    required this.password,
    this.fcmToken,
    required this.passwordConfirmation,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      phone: json['phone'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      fcmToken: json['fcm_token'] as String?,
      passwordConfirmation: json['password_confirmation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'phone': phone,
      'name': name,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (fcmToken != null) {
      data['fcm_token'] = fcmToken!;
    }
    return data;
  }
}
