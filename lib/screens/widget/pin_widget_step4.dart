import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:gb_e_kyc/api/storeState.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:gb_e_kyc/widgets/dialog/customDialog.dart';
import 'package:gb_e_kyc/widgets/errorMessages.dart';
import 'package:gb_e_kyc/widgets/numpad.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PinWidget extends StatefulWidget {
  const PinWidget({Key? key}) : super(key: key);

  @override
  State<PinWidget> createState() => _PinWidgetState();
}

class _PinWidgetState extends State<PinWidget> {
  final _eKYCController = Get.find<EKYCController>();
  final _infoController = Get.find<InformationController>();

  bool resetPIN = false;
  bool _pinSetVisible = true;

  // bool _pinConfirmVisible = false;
  int length = 6;
  bool isLoading = false;
  String? fileNameFrontID;
  late String fileNameBackID;
  String fileNameSelfieID = '';
  var resCreateUser, onTapRecognizer, imgLivenessUint8;
  String? fileNameLiveness = '';
  String? _userLoginID;

  @override
  Widget build(BuildContext context) {
    return _pinSetVisible
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('set_pin'.tr, style: TextStyle(fontSize: 24)),
                  Text('enter_pin'.tr, style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Numpad(
                    length: length,
                    onChange: onChangeSetPIN,
                    reset: resetPIN,
                  ),
                ],
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'confirm_pin'.tr,
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'confirm_enter_pin'.tr,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Numpad(
                    length: length,
                    onChange: onChangeConfirmPIN,
                    reset: resetPIN,
                  )
                ],
              ),
            ),
          );
  }

  onChangeSetPIN(String number) {
    if (regExpPIN.hasMatch(number)) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomDialog(
          title: 'invalid_pin'.tr,
          content: 'You_set_a_PIN_that_is_too_strong_to_guess'.tr,
          avatar: false,
          onPressedConfirm: () {
            setState(() => resetPIN = true);
            Navigator.pop(context);
          },
        ),
      );
    } else if (number.length == 6) {
      setState(() {
        _eKYCController.cPin.text = number;
        _pinSetVisible = false;
        resetPIN = true;
      });
    }
  }

  onChangeConfirmPIN(String number) async {
    if (number.length == length) {
      if (number == _eKYCController.cPin.text) {
        if (_infoController.pathSelfie.isNotEmpty) {
          // setState(() => isLoading = true);
          EasyLoading.show();
          final resFrontID = await PostAPI().callFormData(
            url: '$hostRegister/users/upload_file',
            headers: Authorization.auth2,
            files: [
              http.MultipartFile.fromBytes(
                'image',
                File(_infoController.pathFrontCitizen).readAsBytesSync(),
                filename: File(_infoController.pathFrontCitizen).path.split("/").last,
              )
            ],
          );
          fileNameFrontID = resFrontID['response']['data']['file_name'];

          final resBackID = await PostAPI().callFormData(
            url: '$hostRegister/users/upload_file',
            headers: Authorization.auth2,
            files: [
              http.MultipartFile.fromBytes(
                'image',
                File(_infoController.pathBackCitizen).readAsBytesSync(),
                filename: File(_infoController.pathBackCitizen).path.split("/").last,
              )
            ],
          );
          fileNameBackID = resBackID['response']['data']['file_name'];

          final resSelfieID = await PostAPI().callFormData(
            url: '$hostRegister/users/upload_file',
            headers: Authorization.auth2,
            files: [
              http.MultipartFile.fromBytes(
                'image',
                File(_infoController.pathSelfie.value).readAsBytesSync(),
                filename: File(_infoController.pathSelfie.value).path.split("/").last,
              )
            ],
          );
          fileNameSelfieID = resSelfieID['response']['data']['file_name'];

          await File(_infoController.pathFrontCitizen).delete();
          await File(_infoController.pathBackCitizen).delete();
          await File(_infoController.pathSelfie.value).delete();

          resCreateUser = await PostAPI().call(
            url: '$hostRegister/users',
            headers: Authorization.auth2,
            body: {
              "id_card": _infoController.idCardController.text,
              "first_name": _infoController.firstNameController.text,
              "last_name": _infoController.lastNameController.text,
              "address": _infoController.addressController.text,
              "birthday": _infoController.birthdayController.text,
              "pin": _eKYCController.cPin.text,
              "send_otp_id": _eKYCController.sendOtpId.value,
              "laser": _infoController.ocrBackLaser.value,
              "province_id": '${_infoController.indexProvince}',
              "district_id": '${_infoController.indexDistric}',
              "sub_district_id": '${_infoController.indexSubDistric}',
              "career_id": '${_infoController.careerID}',
              "work_name": _infoController.workNameController.text,
              "work_address": '${_infoController.workAddressController.text} ${_infoController.workAddressSerchController.text}',
              "file_front_citizen": fileNameFrontID!,
              "file_back_citizen": fileNameBackID,
              "file_selfie": fileNameSelfieID,
              "file_liveness": fileNameLiveness!,
              "imei": StoreState.deviceSerial.value,
              "fcm_token": StoreState.fcmToken.value,
            },
          );

          if (resCreateUser['success']) {
            // _userLoginID = resCreateUser['response']['data']['user_login_id'];
            // var data = await PostAPI().call(
            //   url: '$hostRegister/user_logins/$_userLoginID/login',
            //   headers: Authorization.none,
            //   body: {"imei": StoreState.deviceSerial.value, "pin": _eKYCController.cPin.text},
            // );
            //
            // if (data['success']) {
            //   StoreState.token.value = data['response']['data']['token'];
            //   StoreState.approve.value = data['response']['data']['is_ocr_approve'];
            //   StoreState.role.value = data['response']['data']['role_code'];
            //   StoreState.lastLoginAt.value = data['response']['data']['last_login_at'] ?? '';
            //   await LocalStorage.setUserLoginID('');
            //   await LocalStorage.setAutoPIN(false);
            //   await LocalStorage.setTimeToken(DateTime.now().toString());
            //
            //   showDialog(
            //     barrierDismissible: false,
            //     context: context,
            //     builder: (context) => CustomDialog(
            //       title: 'save_success'.tr,
            //       content: 'congratulations_now'.tr,
            //       textConfirm: "back_to_main".tr,
            //       onPressedConfirm: () => Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(builder: (context) => Menu()),
            //             (Route<dynamic> route) => false,
            //       ),
            //     ),
            //   );
            // }
          } else {
            EasyLoading.dismiss();
            setState(() {
              // isLoading = false;
              resetPIN = true;
            });
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => CustomDialog(
                title: "Something_went_wrong".tr,
                content: errorMessages(resCreateUser),
                avatar: false,
                onPressedConfirm: () {
                  Navigator.pop(context);
                  setState(() {
                    // selectedStep = 2;
                    // _pinConfirmVisible = false;
                  });
                },
              ),
            );
          }
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => CustomDialog(
              title: 'success_pin'.tr,
              content: 'sub_success_pin'.tr,
              onPressedConfirm: () => setState(() {
                Navigator.pop(context);
                // selectedStep = 4;
                // _pinConfirmVisible = false;
                // _kycVisible = true;
                resetPIN = true;
              }),
            ),
          );
        }
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => CustomDialog(
            title: 'invalid_pin'.tr,
            content: 'please_enter_again'.tr,
            avatar: false,
            onPressedConfirm: () {
              setState(() => resetPIN = true);
              Navigator.of(context).pop();
            },
          ),
        );
      }
    }
  }
}

RegExp regExpPIN = RegExp(r'123456|234567|345678|456789|567890|678901|789012|890123|901234|012345|111111|222222|333333|444444|555555|666666|777777|888888|999999|000000');
