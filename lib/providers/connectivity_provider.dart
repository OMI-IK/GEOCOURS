import 'dart:async';
import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  StreamSubscription<bool>? _subscription;
  
  bool get isOnline => _isOnline;
  String get status => _isOnline ? 'En ligne' : 'Hors ligne';
  
  Future<void> init() async {
    _isOnline = await ConnectivityService.checkConnectivity();
    _subscription = ConnectivityService.connectivityStream.listen((isConnected) {
      _isOnline = isConnected;
      notifyListeners();
    });
    notifyListeners();
  }
  
  Future<void> check() async {
    _isOnline = await ConnectivityService.checkConnectivity();
    notifyListeners();
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}