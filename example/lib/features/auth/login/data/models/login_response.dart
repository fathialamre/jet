class LoginResponse {
  final String token;

  const LoginResponse({
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginResponse && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginResponse(token: ${token.substring(0, 10)}...)';
}
