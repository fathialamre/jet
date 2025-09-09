class RegisterResponse {
  final String ttl;

  RegisterResponse({required this.ttl});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(ttl: json['ttl']);
  }

  Map<String, dynamic> toJson() {
    return {'ttl': ttl};
  }

}