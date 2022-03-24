// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gb_e_kyc/api/httpClient/interceptedClient.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/widgets/errorMessages.dart';
import 'package:get/get.dart';

import '../widgets/dialog/customDialog.dart';

class GetAPI extends HttpInterceptedClient {
  Future<Map> call({
    required String url,
    required Authorization headers,
  }) async {
    try {
      final response = await client.get(Uri.parse(url), headers: setHeaders(headers)).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data['success']) {
          await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(data), avatar: false));
        }
        return data;
      } else {
        await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(errorNotFound), avatar: false));
        return errorNotFound;
      }
    } on TimeoutException catch (_) {
      await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(errorTimeout), avatar: false));
      return errorTimeout;
    } on SocketException catch (_) {
      await Get.dialog(CustomDialog(title: 'Something_went_wrong'.tr, content: errorMessages(messageOffline), avatar: false));
      return messageOffline;
    }
  }
}
