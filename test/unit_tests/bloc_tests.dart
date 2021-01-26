import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

import 'package:reddit_app/app/pages/home/posts_bloc/posts_bloc.dart';
import 'package:reddit_app/device/connection/connectivity_bloc.dart';
import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';

import 'mock_repositories/mock_news_repository.dart';
import 'mock_services/mock_connactivity.dart';

void main() {
  GetIt.I.registerSingleton<NewsRepository>(MockNewsRepository());

  group('connectivity bloc', () {
    ConnectivityBloc _connectivityBloc;
    MockConnectivity _connectivity;

    setUp(() {
      _connectivity = MockConnectivity();
      _connectivityBloc = ConnectivityBloc(_connectivity);
    });

    tearDown(() {
      _connectivityBloc.close();
    });

    test('initial state is ConnectivityInitial', () {
      expect(_connectivityBloc.state, TypeMatcher<ConnectivityInitial>());
    });

    blocTest(
      'emits ConnectivitySuccess() if network connection active',
      build: () => _connectivityBloc,
      act: (bloc) {
        _connectivity.connectivityCase = ConnectivityCase.success;
      },
      expect: [ConnectivitySuccess()],
    );

    blocTest(
      'emits ConnectivityFailure() if no network connection',
      build: () => _connectivityBloc,
      act: (bloc) {
        _connectivity.connectivityCase = ConnectivityCase.error;
      },
      expect: [ConnectivityFailure()],
    );
  });

  group('home bloc', () {
    PostsBloc _postsBloc;

    setUp(() {
      _postsBloc = PostsBloc();
    });

    tearDown(() {
      _postsBloc.close();
    });

    test('initial state is PostsInitial', () {
      expect(_postsBloc.state, TypeMatcher<PostsInitial>());
    });

    blocTest(
      'emits PostsStates when PostsUpdated() is added',
      build: () => _postsBloc,
      expect: [
        PostsLoadInProgress(),
        PostsFetched([
          Post(
            title: 'App Feedback Thread - January 15, 2021',
            author: 't2_6l4z3',
            text: '',
            created: DateTime.fromMillisecondsSinceEpoch(1610748023 * 1000),
            url: 'https://www.reddit.com/r/FlutterDev/comments/kxv2em/app_feedback_thread_january_15_2021/',
            commentsAmount: 10,
          ),
        ])
      ],
    );
  });
}
