import 'package:json_annotation/json_annotation.dart';

part 'comment_request.g.dart';

@JsonSerializable()
class CommentRequest {
  final String title;
  final String description;
  final String priority;

  const CommentRequest({
    required this.title,
    required this.description,
    required this.priority,
  });

  factory CommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CommentRequestToJson(this);
}
