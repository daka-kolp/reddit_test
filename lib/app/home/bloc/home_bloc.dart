import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/entities/news.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final News news;

  StreamSubscription _connectionListener;

  HomeBloc()
      : news = News.I,
        super(InitialPostsState()) {
    _connectionListener = Connectivity()
        .onConnectivityChanged
        .listen((result) => add(UpdatePostsEvent()));
    add(UpdatePostsEvent());
  }

  List<Post> _cashedPosts = [];

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is UpdatePostsEvent) yield* _getUpdatePosts();
  }

  Stream<HomeState> _getUpdatePosts() async* {
    yield LoadingState();
    try {
      try {
        await news.downloadPosts();
      } on SocketException catch (e){
        yield ConnectionErrorState(_cashedPosts, e.toString());
      }
      _cashedPosts = await news.getPosts();
      yield FetchedPostsState(_cashedPosts);
    } catch (e) {
      yield ErrorState(_cashedPosts, e.toString());
    }
  }

  @override
  Future<void> close() async {
    await _connectionListener.cancel();
    return super.close();
  }
}
