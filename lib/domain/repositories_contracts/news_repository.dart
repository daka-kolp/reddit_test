import 'package:reddit_app/domain/entities/post.dart';

abstract class NewsRepository {
  Future<void> downloadPosts();

  Future<List<Post>> getPosts();
}
