import 'package:connectivity/connectivity.dart';

enum ConnectivityCase { error, success }

class MockConnectivity implements Connectivity {
  ConnectivityCase connectivityCase = ConnectivityCase.success;

  Stream<ConnectivityResult> _onConnectivityChanged;

  @override
  Future<ConnectivityResult> checkConnectivity() {
    if (connectivityCase == ConnectivityCase.success) {
      return Future.value(ConnectivityResult.wifi);
    } else {
      return Future.value(ConnectivityResult.none);
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    if (_onConnectivityChanged == null) {
      _onConnectivityChanged = Stream<ConnectivityResult>.fromFutures([
        Future.value(ConnectivityResult.wifi),
        Future.value(ConnectivityResult.none),
        Future.value(ConnectivityResult.mobile)
      ]).asyncMap((data) async {
        await Future.delayed(const Duration(seconds: 1));
        return data;
      });
    }
    return _onConnectivityChanged;
  }
}
