part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  List<Object> get props => [];
}

class PostsUpdated extends HomeEvent {}
