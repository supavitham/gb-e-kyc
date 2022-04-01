import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:gb_e_kyc/screens/dialog/dialogKYCFail.dart';
import 'package:gb_e_kyc/widgets/dialog/customDialog.dart';
import 'package:gb_e_kyc/widgets/errorMessages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class KYCController extends GetxController {
  final _infoController = Get.put(InformationController());

  static const facetecChannel = const MethodChannel('GBWallet');

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var detailKYCWidget = true.obs;
  var failFaceMatch = 0.obs;
  File? imgLiveness;

  getLivenessFacetec() async {
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
    try {
      var result = await facetecChannel.invokeMethod('getImageFacetec');
      var imgLivenessUint8 = base64Decode(result);
      String dir = (await getApplicationDocumentsDirectory()).path;
      String fullPath = '$dir/imageFacetec.png';
      imgLiveness = File(fullPath);
      await imgLiveness!.writeAsBytes(imgLivenessUint8);
    } on PlatformException catch (e) {
      debugPrint("Failed to get : '${e.message}'");
    }
  }

  getResultFacetec() async {
    try {
      isSuccess.value = await facetecChannel.invokeMethod('getResultFacetec');
      if (isSuccess.value) {
        isLoading.value = true;
        await getImageFacetec();

        final res = await PostAPI().callFormData(
          closeLoading: true,
          url: '$hostRegister/user_profiles/rekognition',
          headers: Authorization.auth2,
          files: [
            http.MultipartFile.fromBytes('face_image', imgLiveness!.readAsBytesSync(), filename: imgLiveness!.path.split("/").last),
            http.MultipartFile.fromBytes('card_image', _infoController.imgFrontIDCardBytes!, filename: _infoController.imgFrontIDCard!.path.split("/").last),
            http.MultipartFile.fromString('id_card', _infoController.idCardController.text),
          ],
        );
        final data = res['response']['data'];
        print("similarity >>>> ${data['similarity']}");

        if (data['similarity'] > 90) {
          _infoController.fileNameFrontID.value = data['card_image_file_name'];
          final resBackID = await PostAPI().callFormData(
            url: '$hostRegister/users/upload_file',
            headers: Authorization.auth2,
            files: [
              http.MultipartFile.fromBytes(
                'image',
                _infoController.imgBackIDCardBytes!,
                filename: _infoController.imgBackIDCard!.path.split("/").last,
              )
            ],
          );
          _infoController.fileNameBackID.value = resBackID['response']['data']['file_name'];
          _infoController.fileNameLiveness.value = data['face_image_file_name'];

          await _infoController.imgFrontIDCard!.delete();
          await _infoController.imgBackIDCard!.delete();
          await imgLiveness!.delete();

          var resCreateUser = await _infoController.createUser();

          isLoading.value = false;
          if (resCreateUser['success']) {
            showDialog(
              barrierDismissible: false,
              context: Get.context!,
              builder: (context) => CustomDialog(
                title: 'save_success'.tr,
                content: 'congratulations'.tr,
                textConfirm: "back_to_main".tr,
                onPressedConfirm: () {
                  Get.back();
                  Get.back();
                }
              ),
            );

          } else {
            showDialog(
              barrierDismissible: false,
              context: Get.context!,
              builder: (context) => CustomDialog(
                title: "Something_went_wrong".tr,
                content: errorMessages(resCreateUser),
                avatar: false,
                onPressedConfirm: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
        } else {
          isLoading.value = false;
          failFaceMatch++;
          if (failFaceMatch.value > 2) {
            showDialog(
              barrierDismissible: false,
              context: Get.context!,
              builder: (context) => DialogKYCFail(),
            );
          } else {
            showDialog(
              barrierDismissible: false,
              context: Get.context!,
              builder: (context) => CustomDialog(
                title: 'facematch'.tr,
                content: 'sub_facematch'.tr,
                avatar: false,
              ),
            );
          }
        }
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get : '${e.message}'");
    } catch (e){
      print("getResultFacetec : $e");
    }
  }
}
