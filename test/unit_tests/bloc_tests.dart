import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';
import 'package:reddit_app/app/pages/home/posts_bloc/posts_bloc.dart';
import 'package:reddit_app/device/connection/connectivity_bloc.dart';

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

    test('initial state is ConnectivityInitial', () {
      expect(_connectivityBloc.state, TypeMatcher<ConnectivityInitial>());
    });

    blocTest(
      'emits ConnectivitySuccess() if network connection active',
      build: () => _connectivityBloc,
      act: (bloc) {
        _connectivity.connectivityCase = ConnectivityCase.success;
        bloc.add(ConnectivityChecked());
      },
      expect: [ConnectivitySuccess()],
    );

    blocTest(
      'emits ConnectivityFailure() if no network connection',
      build: () => _connectivityBloc,
      act: (bloc) {
        _connectivity.connectivityCase = ConnectivityCase.error;
        bloc.add(ConnectivityChecked());
      },
      expect: [ConnectivityFailure()],
    );
  });

  group('home bloc', () {
    PostsBloc _postsBloc;

    setUp(() {
      _postsBloc = PostsBloc();
    });

    test('initial state is PostsInitial', () {
      expect(_postsBloc.state, TypeMatcher<PostsInitial>());
    });
  });
}
