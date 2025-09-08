import 'package:example/features/posts/data/models/post_response.dart';
import 'package:example/features/posts/data/post_service.dart';
import 'package:jet/jet_framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_notifier.g.dart';

@riverpod
Future<List<PostResponse>> postsNotifier(Ref ref) async {
  return await ref.read(postServiceProvider).posts();
}

@riverpod
Future<PostResponse> postDetails(Ref ref, int id) async {
  return await ref.read(postServiceProvider).singlePost(id);
}
