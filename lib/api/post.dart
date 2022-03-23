// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gb_e_kyc/api/httpClient/interceptedClient.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/widgets/dialog/customDialog.dart';
import 'package:gb_e_kyc/widgets/errorMessages.dart';
import 'package:get/get.dart';

class PostAPI extends HttpInterceptedClient {
   Future<Map> call({
    required String url,
    required Authorization headers,
    required Map<String, String> body,
  }) async {
    try {
      EasyLoading.show();
      final response = await client.post(Uri.parse(url), headers: setHeaders(headers), body: body).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        EasyLoading.dismiss();
        if (!data['success']) {
          await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(data), avatar: false));
        }
        return data;
      } else {
        EasyLoading.dismiss();
        await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(errorNotFound), avatar: false));
        return errorNotFound;
      }
    } on TimeoutException catch (_) {
      EasyLoading.dismiss();
      await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(errorTimeout), avatar: false));
      return errorTimeout;
    } on SocketException catch (_) {
      EasyLoading.dismiss();
      await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(messageOffline), avatar: false));
      return messageOffline;
    }
  }


  Future<Map> sendOTP({required String phoneNumber, required String countryCode}) async {
    var res = await call(
      url: '$hostRegister/send_otps',
      headers:  Authorization.auth2,
      body: {
        "phone_number": phoneNumber,
        "country_code": countryCode,
      },
    );

    return res;
  }
}
