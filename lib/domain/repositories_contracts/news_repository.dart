import 'package:reddit_app/domain/entities/post.dart';

abstract class NewsRepository {
  Future<Stream> downloadPosts();

  Future<List<Post>> getPosts();
}
