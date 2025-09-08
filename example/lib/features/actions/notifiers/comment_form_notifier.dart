import 'dart:math';

import 'package:example/features/actions/data/models/comment_request.dart';
import 'package:example/features/actions/data/models/comment_response.dart';
import 'package:jet/jet_framework.dart';

class CommentFormNotifier
    extends JetFormNotifier<CommentRequest, CommentResponse> {
  CommentFormNotifier(super.ref);

  @override
  CommentRequest decoder(Map<String, dynamic> json) {
    return CommentRequest.fromJson(json);
  }

  @override
  Future<CommentResponse> action(CommentRequest data) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Simulate random failure (20% chance)
    if (Random().nextDouble() < 0.2) {
      throw Exception('Failed to create comment. Please try again.');
    }

    // Return successful response
    return CommentResponse(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      title: data.title,
      description: data.description,
      priority: data.priority,
      createdAt: DateTime.now(),
    );
  }
}

// Provider for the comment form
final commentFormProvider = JetFormProvider<CommentRequest, CommentResponse>(
  (ref) => CommentFormNotifier(ref),
);
