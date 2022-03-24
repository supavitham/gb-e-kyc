import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gb_e_kyc/model/personalInfoModel.dart';
import 'package:get/get.dart';

class InformationController extends GetxController{
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

  File? imgFrontIDCard, imgBackIDCard, imgLiveness;
  late String pathFrontCitizen;
  late String pathBackCitizen;
  var pathSelfie = ''.obs;

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

}