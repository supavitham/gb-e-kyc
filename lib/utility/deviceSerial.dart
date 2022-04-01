import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:gb_e_kyc/api/storeState.dart';

Future<void> initDeviceSerial() async {
  try {
    if (Platform.isAndroid) {
      var data = await DeviceInfoPlugin().androidInfo;
      StoreState.deviceSerial.value = data.androidId!;
      print('Device ID : ${StoreState.deviceSerial}');
    } else if (Platform.isIOS) {
      var data = await DeviceInfoPlugin().iosInfo;
      StoreState.deviceSerial.value = data.identifierForVendor!;
      print('Device ID : ${StoreState.deviceSerial}');
    }
  } on PlatformException {
    StoreState.deviceSerial.value = '';
  }
}
