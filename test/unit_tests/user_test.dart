import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:reddit_app/data/models/reddit_post_model.dart';
import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/entities/user.dart';
import 'package:reddit_app/domain/repositories_contracts/user_repository.dart';
import 'package:test/test.dart';

void main() {
  group('get posts', () {
    GetIt.I.registerSingleton<UserRepository>(MockUserRepository());
    User _user;

    setUp(() {
      _user = User.I;
    });

    test('check list', () async {
      final posts = await _user.getPosts();

      expect(posts, equals(TypeMatcher<List<Post>>()));
      expect(posts.length, equals(26));
    });

    test('check post', () async {
      final posts = await _user.getPosts();
      expect(posts.first, equals(Post(
        title: 'App Feedback Thread - January 15, 2021',
        author: 't2_6l4z3',
        text:  'This thread is for getting feedback on your own apps.\n\n## Developers:\n\n* must **provide feedback** for others\n* must include **Play Store**, **App Store**, **GitHub**, **GitLab**, or **BitBucket** link\n* must make top level comment\n* must make effort to respond to questions and feedback from commenters\n* may be open or closed source\n\n## Commenters:\n\n* must give **constructive feedback** in replies to top level comments\n* must not include links to other apps\n\nTo cut down on spam, accounts who are too young or do not have enough karma to post will be removed. Please make an effort to contribute to the community before asking for feedback.\n\nAs always, the mod team is only a small group of people, and we rely on the readers to help us maintain this subreddit. Please report any rule breakers. Thank you.\n\n\\- r/FlutterDev Mods',
        created: DateTime.fromMillisecondsSinceEpoch(1610748023 * 1000),
        url: 'https://www.reddit.com/r/FlutterDev/comments/kxv2em/app_feedback_thread_january_15_2021/',
        commentsAmount: 10,
      )));
    });
  });
}

class MockUserRepository extends UserRepository {
  Map<String, dynamic> _postsJson;

  MockUserRepository() {
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
      File('test/unit_tests/$name').readAsStringSync();
}
