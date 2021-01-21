import 'package:reddit_app/domain/entities/post.dart';

abstract class UserRepository {
  Future<void> downloadPosts();

  Future<List<Post>> getPosts();
}
