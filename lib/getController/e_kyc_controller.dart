import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum StepKYC { one, two, three, four, five }

class SelectStepKYC {
  late StepKYC select;
  late bool statusDone;

  @override
  String toString() {
    return 'SelectStepKYC{select: $select, statusDone: $statusDone}';
  }
}

class EKYCController extends GetxController {
  final cPhoneNumber = TextEditingController();
  final cOTP = TextEditingController();
  late StreamController<ErrorAnimationType> errorController;

  var selectStepKYC = StepKYC.one.obs;
  var processStepKYC = <SelectStepKYC>[].obs;
  var hasErrorOTP = false.obs;
  var expiration = true.obs;

  String countryCode = "+66";
  var sendOtpId = ''.obs;

  DateTime? datetimeOTP;

  @override
  void onInit() {
    SelectStepKYC newSelectStepKYC = SelectStepKYC();
    newSelectStepKYC.select = StepKYC.one;
    newSelectStepKYC.statusDone = false;
    processStepKYC.add(newSelectStepKYC);

    super.onInit();
  }

  autoSubmitPhoneNumber() async {
    String txPhoneNumber = cPhoneNumber.text.replaceAll('-', '');

    // var otpId = await PostAPI().sendOTP(phoneNumber: txPhoneNumber, countryCode: countryCode);

    if (processStepKYC.where((element) => element.select == StepKYC.two).isEmpty) {
      // update status step 1

      var r = processStepKYC.firstWhere((p0) => p0.select == StepKYC.one);
      r.statusDone = true;
      //processStepKYC[0] = r;
      // next step 2
      SelectStepKYC newSelectStepKYC = SelectStepKYC();
      newSelectStepKYC.select = StepKYC.two;
      newSelectStepKYC.statusDone = false;
      selectStepKYC.value = StepKYC.two;
      processStepKYC.add(newSelectStepKYC);
    }

    // if (otpId['success']) {
    //   var data = otpId['response']['data'];
    //
    //   sendOtpId.value = data['send_otp_id'];
    //   datetimeOTP = DateTime.parse(data['expiration_at']);
    //
    //   if (processStepKYC.where((element) => element.select == StepKYC.two).isEmpty) {
    //     // update status step 1
    //     processStepKYC.firstWhere((p0) => p0.select == StepKYC.one).statusDone = true;
    //     // next step 2
    //     SelectStepKYC newSelectStepKYC = SelectStepKYC();
    //     newSelectStepKYC.select = StepKYC.two;
    //     newSelectStepKYC.statusDone = false;
    //     selectStepKYC.value = StepKYC.two;
    //     processStepKYC.add(newSelectStepKYC);
    //   }
    //   expiration.value = false;
    // }
  }

  autoSubmitOTP() async {
    hasErrorOTP.value = false;

    // var data = await PostAPI().call(
    //   url: '$hostRegister/send_otps/$sendOtpId/verify',
    //   headers: Authorization.auth2,
    //   body: {"otp": cOTP.text},
    // );

    if (processStepKYC.where((element) => element.select == StepKYC.three).isEmpty) {
      // update status step 2
      var r = processStepKYC.firstWhere((p0) => p0.select == StepKYC.two).statusDone = true;
      // next step 3
      SelectStepKYC newSelectStepKYC = SelectStepKYC();
      newSelectStepKYC.select = StepKYC.three;
      newSelectStepKYC.statusDone = false;
      selectStepKYC.value = StepKYC.three;
      processStepKYC.add(newSelectStepKYC);
    }

    // if (!data['success']) {
    //   errorController.add(ErrorAnimationType.shake);
    //   hasErrorOTP.value = true;
    // } else {
    //   hasErrorOTP.value = false;
    //   expiration.value = true;
    //   if (processStepKYC.where((element) => element.select == StepKYC.three).isEmpty) {
    //     // update status step 2
    //     var r = processStepKYC.firstWhere((p0) => p0.select == StepKYC.two).statusDone = true;
    //     // next step 3
    //     SelectStepKYC newSelectStepKYC = SelectStepKYC();
    //     newSelectStepKYC.select = StepKYC.three;
    //     newSelectStepKYC.statusDone = false;
    //     selectStepKYC.value = StepKYC.three;
    //     processStepKYC.add(newSelectStepKYC);
    //   }
    // }
  }
}
