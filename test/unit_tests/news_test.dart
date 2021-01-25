import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/entities/news.dart';
import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';

import 'mock_repositories/mock_news_repository.dart';

void main() {
  GetIt.I.registerSingleton<NewsRepository>(MockNewsRepository());

  group('get posts', () {
    News _news;

    setUp(() {
      _news = News.I;
    });

    test('check list : success', () async {
      final posts = await _news.getPosts();

      expect(posts, equals(TypeMatcher<List<Post>>()));
      expect(posts.length, equals(1));
    });

    test('check post : success', () async {
      final posts = await _news.getPosts();
      expect(
        posts.first,
        equals(
          Post(
            title: 'App Feedback Thread - January 15, 2021',
            author: 't2_6l4z3',
            text: '',
            created: DateTime.fromMillisecondsSinceEpoch(1610748023 * 1000),
            url: 'https://www.reddit.com/r/FlutterDev/comments/kxv2em/app_feedback_thread_january_15_2021/',
            commentsAmount: 10,
          ),
        ),
      );
    });
  });
}


