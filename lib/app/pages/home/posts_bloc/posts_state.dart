part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  final List<Post> posts;

  PostsState(this.posts);

  List<Object> get props => [posts];
}

class PostsInitial extends PostsState {
  PostsInitial() : super([]);
}

class PostsFetched extends PostsState {
  PostsFetched(List<Post> posts) : super(posts);
}

class PostsLoadInProgress extends PostsState {
  PostsLoadInProgress() : super([]);
}

class PostsLoadFailure extends PostsState {
  final String error;

  PostsLoadFailure(List<Post> posts, this.error) : super(posts);

  List<Object> get props => [...super.posts, error];
}
