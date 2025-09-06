import 'package:example/features/posts/data/models/post_response.dart';
import 'package:example/features/posts/data/post_service.dart';
import 'package:jet/jet_framework.dart';

final postsProvider = AutoDisposeFutureProvider<List<PostResponse>>(
  (ref) async {
    return await ref.read(postServiceProvider).posts();
  },
);

final postsDetailsProvider =
    AutoDisposeFutureProvider.family<PostResponse, int>(
      (ref, params) async {
        return await ref.read(postServiceProvider).singlePost(params);
      },
    );
