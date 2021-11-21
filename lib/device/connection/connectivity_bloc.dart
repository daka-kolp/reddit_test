import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;

  StreamSubscription _connectionListener;

  ConnectivityBloc([Connectivity connectivity])
      : _connectivity = connectivity ?? Connectivity(),
        super(ConnectivityInitial()) {
    _connectionListener = _connectivity
        .onConnectivityChanged
        .listen((result) {
      try {
        on<ConnectivityChecked>((event, emit) => _getConnectivityState(emit));
      } catch (e) {
        print(e);
      }
    });
    on<ConnectivityChecked>((event, emit) => _getConnectivityState(emit));
  }


  Future<void> _getConnectivityState(Emitter emit) async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit( ConnectivityFailure());
    } else {
      emit( ConnectivitySuccess());
    }
  }

  @override
  Future<void> close() async {
    await _connectionListener.cancel();
    return super.close();
  }
}
