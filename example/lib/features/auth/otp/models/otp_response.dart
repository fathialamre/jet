class OtpResponse {
  final String name;

  OtpResponse({required this.name});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(name: json['name']);
  }
}