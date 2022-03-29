import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:gb_e_kyc/api/storeState.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/model/personalInfoModel.dart';
import 'package:gb_e_kyc/widgets/dialog/customDialog.dart';
import 'package:gb_e_kyc/widgets/errorMessages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InformationController extends GetxController{
  final _eKYCController = Get.put(EKYCController());

  final idCardController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final birthdayController = TextEditingController();
  final workNameController = TextEditingController();
  final workAddressController = TextEditingController();
  final workAddressSerchController = TextEditingController();

  var acceptScanCardIDWidget = true.obs;
  var personalInfo = PersonalInfoModel().obs;
  var ocrBackLaser = ''.obs;
  var ocrFailedAll = false.obs;
  int? careerID;
  int? indexProvince, indexDistric, indexSubDistric;

  File? imgFrontIDCard, imgBackIDCard;
  late String pathFrontCitizen;
  late String pathBackCitizen;
  var pathSelfie = ''.obs;
  var fileNameFrontID = ''.obs;
  var fileNameSelfieID = ''.obs;
  var fileNameBackID = ''.obs;
  var fileNameLiveness = ''.obs;

  setFirstName(String value) => firstNameController.text = value;
  setLastName(String value) => lastNameController.text = value;
  setAddress(String value) => addressController.text = value;
  setBirthday(String value) => birthdayController.text = value;
  setIDCard(String value) => idCardController.text = value;
  setLaserCode(String value) => ocrBackLaser.value = value;
  setCareerID(int value) => careerID = value;
  setWorkName(String value) => workNameController.text = value;
  setWorkAddress(String value) => workAddressController.text = value;
  setWorkAddressSearch(String value) => workAddressSerchController.text = value;
  setindexProvince(int value) => indexProvince = value;
  setindexDistric(int value) => indexDistric = value;
  setindexSubDistric(int value) => indexSubDistric = value;
  setFileFrontCitizen(String value) => pathFrontCitizen = value;
  setFileBackCitizen(String value) => pathBackCitizen = value;
  setFileSelfie(String value) => pathSelfie.value = value;

  verifyStepInfo(bool value) async {
    print("SSSSSS ");
    if(pathSelfie.isNotEmpty){
      print("SSSSSS 111");
      EasyLoading.show();
      final resFrontID = await PostAPI().callFormData(
        url: '$hostRegister/users/upload_file',
        headers: Authorization.auth2,
        files: [
          http.MultipartFile.fromBytes(
            'image',
            File(pathFrontCitizen).readAsBytesSync(),
            filename: File(pathFrontCitizen).path.split("/").last,
          )
        ],
      );

      fileNameFrontID.value = resFrontID['response']['data']['file_name'];

      final resSelfieID = await PostAPI().callFormData(
        url: '$hostRegister/users/upload_file',
        headers: Authorization.auth2,
        files: [
          http.MultipartFile.fromBytes(
            'image',
            File(pathSelfie.value).readAsBytesSync(),
            filename: File(pathSelfie.value).path.split("/").last,
          )
        ],
      );

      fileNameSelfieID.value = resSelfieID['response']['data']['file_name'];

      await File(pathFrontCitizen).delete();
      await File(pathBackCitizen).delete();
      await File(pathSelfie.value).delete();

      var resCreateUser = await PostAPI().call(
        url: '$hostRegister/users',
        headers: Authorization.auth2,
        body: {
          "id_card": idCardController.text,
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "address": addressController.text,
          "birthday": birthdayController.text,
          "pin": _eKYCController.cPin.text,
          "send_otp_id": _eKYCController.sendOtpId.value,
          "laser": ocrBackLaser.value,
          "province_id": '$indexProvince',
          "district_id": '$indexDistric',
          "sub_district_id": '$indexSubDistric',
          "career_id": '$careerID',
          "work_name": workNameController.text,
          "work_address": '${workAddressController.text} ${workAddressSerchController.text}',
          "file_front_citizen": fileNameFrontID.value,
          "file_back_citizen": fileNameBackID.value,
          "file_selfie": fileNameSelfieID.value,
          "file_liveness": fileNameLiveness.value,
          // "imei": StoreState.deviceSerial.value,
          // "fcm_token": StoreState.fcmToken.value,
        },
      );

      if (resCreateUser['success']) {
      } else {
        EasyLoading.dismiss();
        showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (context) => CustomDialog(
            title: "Something_went_wrong".tr,
            content: errorMessages(resCreateUser),
            avatar: false,
            onPressedConfirm: () {
              Navigator.pop(context);
              // setState(() {
              //   // selectedStep = 2;
              //   // _pinConfirmVisible = false;
              // });
            },
          ),
        );
      }
    }else{
      print("SSSSSS 2222");
      Get.put(EKYCController()).setPinStep4();
    }
  }
}