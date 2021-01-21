part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final List<Post> posts;

  HomeState(this.posts);

  List<Object> get props => [posts];
}

class InitialPostsState extends HomeState {
  InitialPostsState() : super([]);
}

class FetchedPostsState extends HomeState {
  FetchedPostsState(List<Post> posts) : super(posts);
}

class LoadingState extends HomeState {
  LoadingState() : super([]);
}

class ErrorState extends HomeState {
  final String error;

  ErrorState(List<Post> posts, this.error) : super(posts);

  List<Object> get props => [...super.props, error];
}

class ConnectionErrorState extends ErrorState {
  ConnectionErrorState(List<Post> posts, String error) : super(posts, error);
}
