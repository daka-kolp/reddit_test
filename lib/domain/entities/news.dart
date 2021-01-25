import 'package:get_it/get_it.dart';

import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';

class News {
  static final News I = News._();

  final NewsRepository _newsRepository;

  News._() : _newsRepository = GetIt.I.get<NewsRepository>();

  Future<Stream> downloadPosts() async {
    return await _newsRepository.downloadPosts();
  }

  Future<List<Post>> getPosts() async {
    return await _newsRepository.getPosts();
  }
}
