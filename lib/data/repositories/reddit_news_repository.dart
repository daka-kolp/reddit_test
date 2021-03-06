import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'package:reddit_app/data/models/reddit_post_model.dart';
import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';

const String _endpoint = 'https://www.reddit.com/r/FlutterDev.json';

class RedditNewsRepository implements NewsRepository {
  final HttpClient _client;

  RedditNewsRepository() : _client = GetIt.I.get<HttpClient>();

  @override
  Future<List<Post>> getPosts() async {
    try {
      final data = await _localFile.then((file) => file.readAsString());
      return await compute(_dataToPostList, data);
    } catch (e) {
      print('RedditNewsRepository getPosts(): $e');
      return [];
    }
  }

  @override
  Future<void> downloadPosts() async {
    await _client.getUrl(Uri.parse(_endpoint)).then(
      (request) async {
        final response = await request.close();
        final file = await _localFile;
        try {
          await file.delete();
        } catch (e) {
          print('RedditNewsRepository downloadPosts(): $e');
        }
        await response.pipe(file.openWrite());
      },
    );
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

List<Post> _dataToPostList(String data) {
  return jsonDecode(data)['data']['children']
      .map<Post>((e) => RedditPostModel.fromJson(e['data']).postFromModel)
      .toList();
}
