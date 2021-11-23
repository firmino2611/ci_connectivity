import 'dart:async';

import 'package:flutter/services.dart';

enum ConnectStatus { none, connected, disconnected }

class CiConnectivity {
  final MethodChannel _channel = const MethodChannel('ci_connectivity');

  /// time to verify connectivity
  int timeCheck = 30;

  /// status of connection
  ConnectStatus status = ConnectStatus.none;
  ConnectStatus _newStatus = ConnectStatus.none;

  /// check if there is any connection service available
  /// return Future<boolean>
  Future<bool> get isNetworkAvailable async =>
      await _channel.invokeMethod('isNetworkAvailable');

  /// checks for network signal. A connection is made
  /// to Google's server to validate if there is a connection possibility
  /// return Future<boolean>
  Future<bool> get checkConnection async =>
      await _channel.invokeMethod('checkConnection');

  /// updates status according to connection check
  Future<void> _getCheckConnection() async {
    await checkConnection
        ? _newStatus = ConnectStatus.connected
        : _newStatus = ConnectStatus.disconnected;
  }

  /// control change status network data
  final _streamController = StreamController<bool>();

  Stream<bool> get onListenerStatusNetwork => _streamController.stream;

  void loopVerifyStatus() {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      await _getCheckConnection();
      if (status != _newStatus) {
        status = _newStatus;
        _streamController.add(
          await CiConnectivity().checkConnection,
        );
      }
    });
  }

  /// closed stream
  dispose() {
    _streamController.close();
  }
}
