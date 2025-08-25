import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final T data;
  final String? message;
  final List<dynamic>? errors;

  BaseResponse(this.data, this.errors, this.message);

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    dynamic Function(T value) toJsonT,
  ) =>
      _$BaseResponseToJson(this, toJsonT);
}
