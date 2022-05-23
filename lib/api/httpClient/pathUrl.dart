import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gb_e_kyc/api/storeState.dart';
import 'package:get/get.dart';

String hostRegister = "https://api-uat.gbwallet.co/register-api";
String hostGateway = "https://api-uat.gbwallet.co/gateway-api";
String authorization2 = "rOewM45nfCS7nYpv";

// String? hostRegister = dotenv.env['host3003'];
// String? hostGateway = dotenv.env['host3006'];
// String? authorization2 = dotenv.env['authorization2'];

Map messageOffline = {
  "success": false,
  "response": {"error_message": "lost_internet_connection".tr}
};

Map errorTimeout = {
  'success': false,
  'response': {'error_message': 'Connection_timeout'.tr}
};

Map errorNotFound = {
  'success': false,
  'response': {'error_message': 'Something_went_wrong_Please_try_again'.tr}
};

enum Authorization { token, auth2, none }

Map<String, String> setHeaders(Authorization headers) {
  print("test >>>> ${authorization2 ?? ""}");
  print("test222 >>>> ${hostRegister ?? ""}");

  switch (headers) {
    case Authorization.token:
      return {HttpHeaders.authorizationHeader: StoreState.token.value, 'lang': 'language'.tr};
    case Authorization.auth2:
      return {'Authorization2': authorization2!, 'lang': 'language'.tr};
    default:
      return {'lang': 'language'.tr};
  }
}
