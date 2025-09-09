class OtpRequest {
  final String otp;
  final String phone;

  OtpRequest({required this.otp, required this.phone});

  factory OtpRequest.fromJson(Map<String, dynamic> json) {
    return OtpRequest(otp: json['otp'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'otp': otp, 'phone': phone};
  }
}
