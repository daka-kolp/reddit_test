part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  List<Object> get props => [];
}

class ConnectivityChecked extends ConnectivityEvent {}
