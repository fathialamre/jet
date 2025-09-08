// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentRequest _$CommentRequestFromJson(Map<String, dynamic> json) =>
    CommentRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
    );

Map<String, dynamic> _$CommentRequestToJson(CommentRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
    };
