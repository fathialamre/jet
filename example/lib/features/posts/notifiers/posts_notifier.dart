import 'package:example/core/networking/app_network.dart';
import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/jet_framework.dart';

final postsProvider =
    AutoDisposeFutureProvider.family<List<PostResponse>, String>(
      (ref, params) async {
        await Future.delayed(const Duration(seconds: 1));
        // You can now use params in your API call
        final posts = await ref.read(appNetworkProvider).posts();
        return posts;
      },
    );

final postsDetailsProvider =
    AutoDisposeFutureProvider.family<PostResponse, int>(
      (ref, params) async {
        await Future.delayed(const Duration(seconds: 1));
        return await ref.read(appNetworkProvider).singlePost(params);
      },
    );
