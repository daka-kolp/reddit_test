import 'package:get_it/get_it.dart';

import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/repositories_contracts/user_repository.dart';

class User {
  static final User I = User._();

  final UserRepository _userRepository;

  User._() : _userRepository = GetIt.I.get<UserRepository>();

  Future<void> downloadPosts() async {
    await _userRepository.downloadPosts();
  }

  Future<List<Post>> getPosts() async {
    return await _userRepository.getPosts();
  }
}
