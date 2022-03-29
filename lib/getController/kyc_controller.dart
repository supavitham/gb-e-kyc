import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:gb_e_kyc/api/storeState.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class KYCController extends GetxController {
  final _infoController = Get.put(InformationController());
  final _eKycController = Get.put(EKYCController());

  static const facetecChannel = const MethodChannel('GBWallet');

  var isLoading = false.obs;
  var isSuccess = false.obs;
  File? imgLiveness;

  getLivenessFacetec() async {
    print("DDDD ${Get.locale.toString()}");
    try {
      isSuccess.value = false;
      await facetecChannel.invokeMethod<String>(
        'getLivenessFacetec',
        {"local": Get.locale.toString() == 'th_TH' ? "th" : "en"},
      );
    } on PlatformException catch (e) {
      debugPrint("Failed to get : '${e.message}'");
    }
  }

  getImageFacetec() async {
    // try {
    //   var result = await facetecChannel.invokeMethod('getImageFacetec');
    //   imgLivenessUint8 = base64Decode(result);
    //   String dir = (await getApplicationDocumentsDirectory()).path;
    //   String fullPath = '$dir/imageFacetec.png';
    //   imgLiveness = File(fullPath);
    //   await imgLiveness!.writeAsBytes(imgLivenessUint8);
    // } on PlatformException catch (e) {
    //   debugPrint("Failed to get : '${e.message}'");
    // }
  }

  getResultFacetec() async {
    try {
      isSuccess.value = await facetecChannel.invokeMethod('getResultFacetec');
      if (isSuccess.value) {
        // setState(() => isLoading = true);
        await getImageFacetec();
        final res = await PostAPI().callFormData(
          closeLoading: true,
          url: '$hostRegister/user_profiles/rekognition',
          headers: Authorization.auth2,
          files: [
            http.MultipartFile.fromBytes('face_image', imgLiveness!.readAsBytesSync(), filename: imgLiveness!.path.split("/").last),
            http.MultipartFile.fromBytes('card_image', _infoController.imgFrontIDCard!.readAsBytesSync(), filename: _infoController.imgFrontIDCard!.path.split("/").last),
            http.MultipartFile.fromString('id_card', _infoController.idCardController.text)
          ],
        );
        final data = res['response']['data'];

        // if (data['similarity'] > 90) {
        //   _infoController.fileNameFrontID.value = data['card_image_file_name'];
        //   final resBackID = await PostAPI().callFormData(
        //     url: '$hostRegister/users/upload_file',
        //     headers: Authorization.auth2,
        //     files: [
        //       http.MultipartFile.fromBytes(
        //         'image',
        //         _infoController.imgBackIDCard!.readAsBytesSync(),
        //         filename: _infoController.imgBackIDCard!.path.split("/").last,
        //       )
        //     ],
        //   );
        //   _infoController.fileNameBackID.value = resBackID['response']['data']['file_name'];
        //   _infoController.fileNameLiveness.value = data['face_image_file_name'];
        //
        //   await _infoController.imgFrontIDCard!.delete();
        //   await _infoController.imgBackIDCard!.delete();
        //   await imgLiveness!.delete();
        //
        //   var resCreateUser = await PostAPI().call(
        //     url: '$hostRegister/users',
        //     headers: Authorization.auth2,
        //     body: {
        //       "id_card": _infoController.idCardController.text,
        //       "first_name": _infoController.firstNameController.text,
        //       "last_name": _infoController.lastNameController.text,
        //       "address": _infoController.addressController.text,
        //       "birthday": _infoController.birthdayController.text,
        //       // "pin": _infoController.pinController.text,
        //       "send_otp_id": _eKycController.sendOtpId.value,
        //       "laser": _infoController.ocrBackLaser.value,
        //       "province_id": '${_infoController.indexProvince}',
        //       "district_id": '${_infoController.indexDistric}',
        //       "sub_district_id": '${_infoController.indexSubDistric}',
        //       "career_id": '${_infoController.careerID}',
        //       "work_name": _infoController.workNameController.text,
        //       "work_address": '${_infoController.workAddressController.text} ${_infoController.workAddressSerchController.text}',
        //       "file_front_citizen": _infoController.fileNameFrontID.value,
        //       "file_back_citizen": _infoController.fileNameBackID.value,
        //       "file_selfie": _infoController.fileNameSelfieID.value,
        //       "file_liveness": _infoController.fileNameLiveness.value,
        //       "imei": StoreState.deviceSerial.value,
        //       "fcm_token": StoreState.fcmToken.value,
        //     },
        //   );
        //
        //   setState(() => isLoading = false);
        //   if (resCreateUser['success']) {
        //     _userLoginID = resCreateUser['response']['data']['user_login_id'];
        //     var data = await PostAPI.call(
        //       url: '$hostRegister/user_logins/$_userLoginID/login',
        //       headers: Authorization.none,
        //       body: {"imei": StoreState.deviceSerial.value, "pin": pinController.text},
        //     );
        //
        //     if (data['success']) {
        //       await LocalStorage.setAutoPIN(false);
        //       await LocalStorage.setUserLoginID(_userLoginID!);
        //       await LocalStorage.setIsCorporate(false);
        //       await LocalStorage.setTimeToken(DateTime.now().toString());
        //
        //       StoreState.role.value = data['response']['data']['role_code'];
        //       StoreState.pin.value = pinController.text;
        //       StoreState.token.value = data['response']['data']['token'];
        //       StoreState.approve.value = data['response']['data']['is_ocr_approve'];
        //
        //       showDialog(
        //         barrierDismissible: false,
        //         context: context,
        //         builder: (context) => CustomDialog(
        //           title: 'save_success'.tr,
        //           content: 'congratulations'.tr,
        //           textConfirm: "back_to_main".tr,
        //           onPressedConfirm: () => Navigator.pushAndRemoveUntil(
        //             context,
        //             MaterialPageRoute(builder: (BuildContext context) => Menu()),
        //                 (Route<dynamic> route) => false,
        //           ),
        //         ),
        //       );
        //     }
        //   } else {
        //     showDialog(
        //       barrierDismissible: false,
        //       context: context,
        //       builder: (context) => CustomDialog(
        //         title: "Something_went_wrong".tr,
        //         content: errorMessages(resCreateUser),
        //         avatar: false,
        //         onPressedConfirm: () {
        //           Navigator.pop(context);
        //           setState(() {
        //             selectedStep = 2;
        //             _kycVisible = false;
        //           });
        //         },
        //       ),
        //     );
        //   }
        // } else {
        //   setState(() => isLoading = false);
        //   failFacematch++;
        //   if (failFacematch > 2) {
        //     showDialog(barrierDismissible: false, context: context, builder: (context) => dialogKYCfail());
        //   } else {
        //     showDialog(
        //       barrierDismissible: false,
        //       context: context,
        //       builder: (context) => CustomDialog(
        //         title: 'facematch'.tr,
        //         content: 'sub_facematch'.tr,
        //         avatar: false,
        //       ),
        //     );
        //   }
        // }
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get : '${e.message}'");
    }
  }
}
