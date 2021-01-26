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
        yield PostsLoadFailure('Impossible to download new posts');
      }
      final posts = await news.getPosts();
      yield PostsFetched(posts);
    } catch (e) {
      yield PostsLoadFailure('Unknown error: $e');
    }
  }
}
