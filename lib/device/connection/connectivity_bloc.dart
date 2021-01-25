import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;

  StreamSubscription _connectionListener;

  ConnectivityBloc()
      : _connectivity = Connectivity(),
        super(ConnectivityInitial()) {
    _connectionListener = _connectivity
      .onConnectivityChanged
      .listen((result) => add(ConnectivityChecked()));
    add(ConnectivityChecked());
  }

  @override
  Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
    if (event is ConnectivityChecked) yield* _getConnectivityState();
  }

  Stream<ConnectivityState> _getConnectivityState() async* {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      yield ConnectivityFailure();
    } else {
      yield ConnectivitySuccess();
    }
  }

  @override
  Future<void> close() async {
    await _connectionListener.cancel();
    return super.close();
  }
}
