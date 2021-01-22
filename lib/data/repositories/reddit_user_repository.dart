import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'package:reddit_app/data/models/reddit_post_model.dart';
import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/repositories_contracts/user_repository.dart';

const String _endpoint = 'https://www.reddit.com/r/FlutterDev.json';

class RedditUserRepository implements UserRepository {
  final HttpClient _client;

  RedditUserRepository() : _client = GetIt.I.get<HttpClient>();

  @override
  Future<List<Post>> getPosts() async {
    try {
      final file = await _localFile;
      final data = await file.readAsString();

      final posts = jsonDecode(data)['data']['children']
        .map<Post>((e) => RedditPostModel.fromJson(e['data']).postFromModel)
        .toList();
      return posts;
    } catch (e) {
      print('RedditUserRepository getPosts(): $e');
      return [];
    }
  }

  @override
  Future<void> downloadPosts() async {
    final file = await _localFile;

    final request = await _client.getUrl(Uri.parse(_endpoint));
    final response = await request.close();
    try {
      await file.delete();
    } catch (e) {
      print('RedditUserRepository downloadPosts(): $e');
    }
    await response.pipe(file.openWrite());
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/posts.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

