import 'package:example/features/posts/data/models/post_response.dart';
import 'package:jet/jet_framework.dart';

class AppNetwork extends JetApiService {
  @override
  String get baseUrl => 'https://jsonplaceholder.typicode.com';

  Future<List<PostResponse>> posts() async {
    final response = await network(
      request: () async {
        final response = await get<List<PostResponse>>(
          '/posts',
          decoder: (data) => (data as List<dynamic>)
              .map((e) => PostResponse.fromJson(e))
              .toList(),
        );
        return response;
      },
    );
    return response;
  }

  Future<PostResponse> singlePost(int id) async {
    final response = await network(
      request: () async {
        final response = await get<PostResponse>(
          '/posts/$id',
          decoder: (data) => PostResponse.fromJson(data),
        );
        return response;
      },
    );
    return response;
  }
}

final appNetworkProvider = AutoDisposeProvider<AppNetwork>(
  (ref) => AppNetwork(),
);
