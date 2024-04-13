import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sparkmob/controller/main_state.dart';

class ConnectionUtil {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  late MainState _state;

  void initConnectvity(MainState mainState) {
    _state = mainState;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void cancel() {
    _connectivitySubscription.cancel();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    print(result);
    if (result.contains(ConnectivityResult.none)) {
      print('网络已断开');
      _state.connectionError.value = true;
    } else {
      print('网络连接成功');
      _state.connectionError.value = false;
    }

    // switch (result) {
    //   case ConnectivityResult.wifi:
    //     print('正在使用 WiFi网络');
    //   case ConnectivityResult.mobile:
    //     print('正在使用 移动网络');
    //   case ConnectivityResult.none:
    //     print('网络已断开');
    //   case ConnectivityResult.ethernet:
    //     print('正在使用 以太网');
    //   case ConnectivityResult.bluetooth:
    //     print('正在使用 蓝牙网络');
    //   case ConnectivityResult.vpn:
    //     print('正在使用 VPN');
    //   case ConnectivityResult.other:
    //     print('正在使用 未知网络');
    // }
  }
}
