part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final List<Post> posts;

  HomeState(this.posts);

  List<Object> get props => [posts];
}

class PostsInitial extends HomeState {
  PostsInitial() : super([]);
}

class PostsFetched extends HomeState {
  PostsFetched(List<Post> posts) : super(posts);
}

class PostsLoadInProgress extends HomeState {
  PostsLoadInProgress() : super([]);
}

class PostsLoadFailure extends HomeState {
  final String error;

  PostsLoadFailure(List<Post> posts, this.error) : super(posts);

  List<Object> get props => [...super.props, error];
}
