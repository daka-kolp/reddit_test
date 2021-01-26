part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  List<Object> get props => [];
}

class PostsInitial extends PostsState {
  PostsInitial();
}

class PostsFetched extends PostsState {
  final List<Post> posts;

  PostsFetched(this.posts);

  List<Object> get props => [posts];
}

class PostsLoadInProgress extends PostsState {
  PostsLoadInProgress();
}

class PostsLoadFailure extends PostsState {
  final String error;

  PostsLoadFailure(this.error);

  List<Object> get props => [error];
}
