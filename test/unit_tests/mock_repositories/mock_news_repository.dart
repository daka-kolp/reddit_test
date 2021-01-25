import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';

import 'package:reddit_app/data/models/reddit_post_model.dart';
import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';

class MockClient extends Mock implements HttpClient {}

class MockClientRequest extends Mock implements HttpClientRequest {}

class MockClientResponse extends Mock implements HttpClientResponse {}

class MockNewsRepository extends NewsRepository {
  final MockClient _client;

  Map<String, dynamic> _postsJson;

  MockNewsRepository() : _client = MockClient() {
    _postsJson = json.decode(_fixture('posts.json'));
  }

  @override
  Future<MockClientResponse> downloadPosts() async {
    final request = await _client.getUrl(Uri.parse('https://www.reddit.com/r/FlutterDev.json'));
    return await request.close();
  }

  @override
  Future<List<Post>> getPosts() async {
    try {
      final posts = _postsJson['data']['children']
          .map<Post>((e) => RedditPostModel.fromJson(e['data']).postFromModel)
          .toList();
      return posts;
    } catch (e) {
      print('MockUserRepository getPosts(): $e');
      return [];
    }
  }

  String _fixture(String name) =>
      File('test/unit_tests/assets/$name').readAsStringSync();
}
