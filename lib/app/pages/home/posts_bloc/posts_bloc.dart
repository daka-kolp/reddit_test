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
    on<PostsUpdated>((event, emit) => _getUpdatePosts(emit));
  }

  Future<void> _getUpdatePosts(Emitter emit) async {
    emit(PostsLoadInProgress());
    try {
      try {
        await news.downloadPosts();
      } on SocketException {
        emit(PostsLoadFailure('Impossible to download new posts'));
      }
      final posts = await news.getPosts();
      emit(PostsFetched(posts));
    } catch (e) {
      emit(PostsLoadFailure('Unknown error: $e'));
    }
  }
}
