import 'dart:convert';
import 'dart:io';

import 'package:reddit_app/data/models/reddit_post_model.dart';
import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';

class MockNewsRepository extends NewsRepository {
  Map<String, dynamic> _postsJson;

  MockNewsRepository() {
    _postsJson = json.decode(_fixture('posts.json'));
  }

  @override
  Future<void> downloadPosts() async {}

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
