import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/entities/user.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final User user;

  HomeBloc()
      : user = User.I,
        super(InitialPostsState()) {
    add(UpdatePostsEvent());
  }

  List<Post> _cashedPosts = [];

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetPostsEvent) yield* _getPosts();
    if (event is UpdatePostsEvent) yield* _getUpdatePosts();
  }

  Stream<HomeState> _getPosts() async* {
    yield LoadingState();
    try {
      _cashedPosts = await user.getPosts();
      yield FetchedPostsState(_cashedPosts);
    } catch (e) {
      yield ErrorState(_cashedPosts, e.toString());
    }
  }

  Stream<HomeState> _getUpdatePosts() async* {
    yield LoadingState();
    try {
      try {
        await user.downloadPosts();
      } on SocketException catch (e){
        yield ConnectionErrorState(_cashedPosts, e.toString());
      }
      _cashedPosts = await user.getPosts();
      yield FetchedPostsState(_cashedPosts);
    } catch (e) {
      yield ErrorState(_cashedPosts, e.toString());
    }
  }
}
