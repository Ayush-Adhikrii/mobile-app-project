import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription; // Updated type
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  ConnectivityService() {
    _checkInitialConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      // Check if any result indicates connectivity
      _isConnected = results.any((result) => result != ConnectivityResult.none);
      print('Connectivity changed: isConnected=$_isConnected');
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isConnected = results.any((result) => result != ConnectivityResult.none);
    print('Initial connectivity: isConnected=$_isConnected');
  }

  void dispose() {
    _subscription.cancel();
  }
}