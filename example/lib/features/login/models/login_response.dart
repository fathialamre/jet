class LoginResponse {
  final String token;
  final String userId;
  final String name;
  final String email;
  final DateTime loginAt;

  const LoginResponse({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
    required this.loginAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    loginAt: DateTime.parse(json['loginAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'userId': userId,
    'name': name,
    'email': email,
    'loginAt': loginAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'LoginResponse(userId: $userId, name: $name, email: $email)';
  }
}
