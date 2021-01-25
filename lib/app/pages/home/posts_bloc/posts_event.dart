part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  List<Object> get props => [];
}

class PostsUpdated extends PostsEvent {}
