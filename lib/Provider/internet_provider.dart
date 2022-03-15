import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Internet with ChangeNotifier {
  bool hasInternet = true;

  bool get getInternet => hasInternet;

  Future<void> checkInternet() async {
    final _connectivity = Connectivity();
    var result = await _connectivity.checkConnectivity();
    trueCheck(result);
    _connectivity.onConnectivityChanged.listen((result) {
      trueCheck(result);
    });
  }

  Future<void> trueCheck(var result) async {
    bool temp;
    switch (result) {
      case ConnectivityResult.wifi:
        try {
          final result = await InternetAddress.lookup('google.com');
          temp = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        } catch (e) {
          temp = false;
        }
        break;
      case ConnectivityResult.mobile:
        try {
          final result = await InternetAddress.lookup('google.com');
          temp = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        } catch (e) {
          temp = false;
        }
        break;
      default:
        temp = false;
        break;
    }
    if (hasInternet != temp) {
      hasInternet = temp;
      notifyListeners();
    }
  }
}
