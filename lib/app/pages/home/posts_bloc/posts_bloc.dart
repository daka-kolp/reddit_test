import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import 'package:reddit_app/domain/entities/post.dart';
import 'package:reddit_app/domain/entities/news.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final News news;

  PostsBloc()
      : news = News.I,
        super(PostsInitial()) {
    add(PostsUpdated());
  }

  List<Post> _cashedPosts = [];

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is PostsUpdated) yield* _getUpdatePosts();
  }

  Stream<PostsState> _getUpdatePosts() async* {
    yield PostsLoadInProgress();
    try {
      try {
        await news.downloadPosts();
      } on SocketException {
        yield PostsLoadFailure(_cashedPosts, 'Impossible to download new posts');
      }
      _cashedPosts = await news.getPosts();
      yield PostsFetched(_cashedPosts);
    } catch (e) {
      yield PostsLoadFailure(_cashedPosts, 'Unknown error: ${e.error}');
    }
  }
}
