import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// Ref. https://www.flutterbeads.com/flutter-internet-connection-checker/#:~:text=To%20check%20the%20internet%20connection%20in%20Flutter%2C%20you%20need%20to,changes%20by%20calling%20its%20onConnectivityChanged
class NetworkConnectivity {
  NetworkConnectivity._();

  static final _instance = NetworkConnectivity._();

  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get networkChangeStream => _controller.stream;

  initialise() async {
    _networkConnectivity.onConnectivityChanged.listen((result) async {
      _checkStatus(result);
    });
  }

  _checkStatus(List<ConnectivityResult> result) async {
    bool isOnline = false;
    if (!result.contains(ConnectivityResult.none)) {
      try {
        final result = await InternetAddress.lookup('example.com');
        isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        isOnline = false;
      }
    }
    _controller.sink.add(isOnline);
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void disposeStream() => _controller.close();
}
