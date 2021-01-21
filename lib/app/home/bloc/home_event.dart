part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable{
  const HomeEvent();

  List<Object> get props => [];
}

class GetPostsEvent extends HomeEvent {
  GetPostsEvent();
}

class UpdatePostsEvent extends HomeEvent {
  UpdatePostsEvent();
}
