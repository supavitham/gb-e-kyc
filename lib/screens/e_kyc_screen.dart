import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gb_e_kyc/api/httpClient/pathUrl.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:gb_e_kyc/api/storeState.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:gb_e_kyc/getController/kyc_controller.dart';
import 'package:gb_e_kyc/screens/widget/information_widget_step_3.dart';
import 'package:gb_e_kyc/screens/widget/kyc_widget_step_4.dart';
import 'package:gb_e_kyc/screens/widget/otp_widget_step_2.dart';
import 'package:gb_e_kyc/screens/widget/phone_number_step_1.dart';
import 'package:gb_e_kyc/utility/deviceSerial.dart';
import 'package:gb_e_kyc/utility/fileUitility.dart';
import 'package:gb_e_kyc/utility/format.dart';
import 'package:gb_e_kyc/widgets/buttonCancel.dart';
import 'package:gb_e_kyc/widgets/buttonConfirm.dart';
import 'package:gb_e_kyc/widgets/cameraScanIDCard.dart';
import 'package:gb_e_kyc/widgets/dialog/customDialog.dart';
import 'package:gb_e_kyc/widgets/dialog/deleteDialog.dart';
import 'package:gb_e_kyc/widgets/errorMessages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EKYCScreen extends StatefulWidget {
  const EKYCScreen({Key? key}) : super(key: key);

  @override
  State<EKYCScreen> createState() => _EKYCScreenState();
}

class _EKYCScreenState extends State<EKYCScreen> {
  final _eKYCController = Get.put(EKYCController());
  final _infoController = Get.put(InformationController());
  final _kycController = Get.put(KYCController());
  final _formKeyPhoneNumber = GlobalKey<FormState>();
  final cOTP = TextEditingController();

  Timer? _timer;

  @override
  void initState() {
    initDeviceSerial();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    cOTP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'register'.tr,
            style: const TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            onPressed: () {
              var nowStep = _eKYCController.selectStepKYC.value;
              return onBackButton(nowStep);
            },
            color: Colors.black,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              height: 80,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: const Divider(
                    color: Color(0xFF02416D),
                    thickness: 1.5,
                    height: 30,
                    indent: 30,
                    endIndent: 20,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: StepKYC.values
                      .map((e) => Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 33,
                                  child: _buildWidgetStep(e),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                    child: Text(
                                  Format.nameStepKYC(e),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                )),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ]),
            ),
          ),
        ),
        body: Obx(() {
          var step = _eKYCController.selectStepKYC.value;
          switch (step) {
            case StepKYC.one:
              return PhoneNumberWidget(
                formKeyPhoneNumber: _formKeyPhoneNumber,
              );
            case StepKYC.two:
              return OTPWidget(cOTP: cOTP);
            case StepKYC.three:
              return const InformationWidget();
            case StepKYC.four:
              return const KYCWidget();
          }
        }),
        bottomNavigationBar: Obx(() {
          var step = _eKYCController.selectStepKYC.value;
          return selectBottomView(step);
        }),
      ),
    );
  }

  onBackButton(StepKYC nowStep) {
    switch (nowStep) {
      case StepKYC.one:
        {
          Get.back();
          break;
        }
      case StepKYC.two:
        {
          // cOTP.clear();
          _eKYCController.cPhoneNumber.clear();
          _eKYCController.hasErrorOTP.value = false;
          // remove step 2
          _eKYCController.processStepKYC.removeWhere((element) => element.select == nowStep);
          // update status step 1
          _eKYCController.processStepKYC.firstWhere((p0) => p0.select == StepKYC.one).statusDone = false;
          _eKYCController.selectStepKYC.value = StepKYC.one;
          break;
        }
      case StepKYC.three:
        {
          // remove step 3
          _eKYCController.processStepKYC.removeWhere((element) => element.select == nowStep);
          // update status step 2
          _eKYCController.processStepKYC.firstWhere((p0) => p0.select == StepKYC.two).statusDone = false;
          _eKYCController.selectStepKYC.value = StepKYC.two;
          break;
        }
      case StepKYC.four:
        {
          // remove step 4
          _eKYCController.processStepKYC.removeWhere((element) => element.select == nowStep);
          // update status step 3
          _eKYCController.processStepKYC.firstWhere((p0) => p0.select == StepKYC.three).statusDone = false;
          _eKYCController.selectStepKYC.value = StepKYC.three;
          break;
        }
    }
  }

  selectBottomView(StepKYC step) {
    switch (step) {
      case StepKYC.one:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
          child: Row(children: [
            Expanded(
              child: ButtonCancel(
                text: 'back'.tr,
                onPressed: () => Get.back(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ButtonConfirm(
                text: 'continue111'.tr,
                onPressed: () async {
                  if (_formKeyPhoneNumber.currentState!.validate() && _eKYCController.cPhoneNumber.text.length == 12) {
                    await _eKYCController.autoSubmitPhoneNumber();
                  }
                },
              ),
            )
          ]),
        );
      case StepKYC.two:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ButtonCancel(
                  text: 'back'.tr,
                  onPressed: () {
                    // cOTP.clear();
                    _eKYCController.cPhoneNumber.clear();
                    _eKYCController.hasErrorOTP.value = false;
                    // back step 1
                    _eKYCController.processStepKYC.removeWhere((element) => element.select == StepKYC.two);
                    _eKYCController.selectStepKYC.value = StepKYC.one;
                    _eKYCController.processStepKYC.firstWhere((p0) => p0.select == StepKYC.one).statusDone = false;
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ButtonConfirm(
                  text: 'continue222'.tr,
                  onPressed: () => _eKYCController.autoSubmitOTP(cOTP.text),
                ),
              ),
            ],
          ),
        );
      case StepKYC.three:
        return _infoController.acceptScanCardIDWidget.value
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
                child: Row(children: [
                  Expanded(
                    child: ButtonConfirm(
                      text: 'accepttoscan'.tr,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScanIDCard(
                              titleAppbar: 'idcard'.tr,
                              isFront: true,
                              noFrame: false,
                              enableButton: false,
                              scanID: true,
                            ),
                          ),
                        ).then((data) {
                          try {
                            if (data != null && !data['ocrFailedAll']) {
                              _infoController.personalInfo.value.idCard = data['ocrFrontID'];
                              _infoController.personalInfo.value.firstName = data['ocrFrontName'];
                              _infoController.personalInfo.value.lastName = data['ocrFrontSurname'];
                              _infoController.personalInfo.value.address = data['ocrFrontAddress'];
                              _infoController.personalInfo.value.filterAddress = data['ocrFilterAddress'];
                              _infoController.personalInfo.value.birthday = data['ocrBirthDay'];
                              _infoController.personalInfo.value.ocrBackLaser = data['ocrBackLaser'];

                              _infoController.idCardController.text = data['ocrFrontID'];
                              _infoController.firstNameController.text = data['ocrFrontName'];
                              _infoController.lastNameController.text = data['ocrFrontSurname'];
                              _infoController.addressController.text = data['ocrFrontAddress'];
                              _infoController.birthdayController.text = data['ocrBirthDay'];
                              _infoController.ocrBackLaser.value = data['ocrBackLaser'];
                              _infoController.ocrFailedAll.value = data['ocrFailedAll'];
                              _infoController.imgFrontIDCard = File(data['frontIDPath']);
                              _infoController.imgBackIDCard = File(data['backIDPath']);
                              _infoController.acceptScanCardIDWidget.value = false;
                              _infoController.imgFrontIDCardBytes = data['frontIDPathFile'];
                              _infoController.imgBackIDCardBytes = data['backIDPathFile'];
                            } else if (data != null && data['ocrFailedAll']) {
                              _infoController.personalInfo.value.idCard = '';
                              _infoController.personalInfo.value.firstName = '';
                              _infoController.personalInfo.value.lastName = '';
                              _infoController.personalInfo.value.address = '';
                              _infoController.personalInfo.value.birthday = '';
                              _infoController.personalInfo.value.ocrBackLaser = '';

                              _infoController.ocrFailedAll.value = data['ocrFailedAll'];
                              _infoController.acceptScanCardIDWidget.value = false;
                            }
                          } catch (e) {}
                        });
                      },
                    ),
                  )
                ]),
              )
            : SizedBox();
      case StepKYC.four:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: _kycController.detailKYCWidget.value
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF115899),
                            Color(0xFF02416D),
                          ],
                        ),
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          _timer?.cancel();
                          // setState(() => isLoading = true);
                          _kycController.isLoading.value = true;
                          _kycController.getLivenessFacetec();

                          if (Platform.isIOS) {
                            print(">>>>>>> ios");
                            Future.delayed(Duration(seconds: 50), () {
                              print(">>>>>>> 50");
                              // setState(() => _kycController.isLoading.value = false);
                              _kycController.isLoading.value = false;
                            });
                          }
                          _timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
                            // print(">>>>>>> 333333");
                            if (_kycController.isSuccess.value)
                              _timer?.cancel();
                            else
                              _kycController.getResultFacetec();
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera_outlined, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'camera'.tr,
                              style: TextStyle(fontSize: 17, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ])
              : _infoController.pathSelfie.isNotEmpty
                  ? Row(children: [
                      Expanded(
                        child: MaterialButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: Color(0xFF115899)),
                          ),
                          child: Text(
                            'Re-take_photo'.tr,
                            style: TextStyle(color: Color(0xFF115899)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScanIDCard(titleAppbar: 'Selfie_ID_Card'.tr, enableButton: true, isFront: true, noFrame: true),
                              ),
                            ).then(
                              (v) async {
                                if (v != null) {
                                  int fileSize = await getFileSize(filepath: v);
                                  if (_infoController.pathSelfie.isNotEmpty) {
                                    await File(_infoController.pathSelfie.value).delete();
                                  }
                                  if (!isImage(v)) {
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return DeleteDialog(
                                          title: "Extension_not_correct".tr,
                                          textConfirm: "ok".tr,
                                          onPressedConfirm: () => Navigator.pop(context),
                                        );
                                      },
                                    );
                                  } else if (fileSize > 10000000) {
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return DeleteDialog(
                                          title: "File_size_larger".tr,
                                          textConfirm: "ok".tr,
                                          onPressedConfirm: () => Navigator.pop(context),
                                        );
                                      },
                                    );
                                  } else {
                                    _kycController.detailKYCWidget.value = false;
                                    _infoController.pathSelfie.value = v;
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF115899),
                                Color(0xFF02416D),
                              ],
                            ),
                          ),
                          child: MaterialButton(
                            child: Text('continue'.tr),
                            onPressed: () async {
                              final resFrontID = await PostAPI().callFormData(
                                url: '$hostRegister/users/upload_file',
                                headers: Authorization.auth2,
                                files: [
                                  http.MultipartFile.fromBytes(
                                    'image',
                                    _infoController.imgFrontIDCard!.readAsBytesSync(),
                                    filename: _infoController.imgFrontIDCard!.path.split("/").last,
                                  )
                                ],
                              );
                              _infoController.fileNameFrontID.value = resFrontID['response']['data']['file_name'];

                              final resBackID = await PostAPI().callFormData(
                                url: '$hostRegister/users/upload_file',
                                headers: Authorization.auth2,
                                files: [
                                  http.MultipartFile.fromBytes(
                                    'image',
                                    _infoController.imgBackIDCard!.readAsBytesSync(),
                                    filename: _infoController.imgBackIDCard!.path.split("/").last,
                                  )
                                ],
                              );
                              _infoController.fileNameBackID.value = resBackID['response']['data']['file_name'];

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
                              _infoController.fileNameSelfieID.value = resSelfieID['response']['data']['file_name'];

                              await _infoController.imgFrontIDCard!.delete();
                              await _infoController.imgBackIDCard!.delete();
                              await File(_infoController.pathSelfie.value).delete();

                              var resCreateUser = await _infoController.createUser();

                              _kycController.isLoading.value = false;

                              if (resCreateUser['success']) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    title: 'save_success'.tr,
                                    content: 'congratulations_now'.tr,
                                    textConfirm: "back_to_main".tr,
                                    onPressedConfirm: () {
                                      Get.back();
                                      Get.back();
                                    },
                                    // onPressedConfirm: () => Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   MaterialPageRoute(builder: (BuildContext context) => Menu()),
                                    //       (Route<dynamic> route) => false,
                                    // ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    title: "Something_went_wrong".tr,
                                    content: errorMessages(resCreateUser),
                                    avatar: false,
                                    onPressedConfirm: () {
                                      Navigator.pop(context);
                                      _kycController.detailKYCWidget.value = false;
                                      _infoController.pathSelfie.value = '';
                                      // remove step 4
                                      _eKYCController.processStepKYC.removeWhere((element) => element.select == StepKYC.four);
                                      // update status step 3
                                      _eKYCController.processStepKYC.firstWhere((p0) => p0.select == StepKYC.three).statusDone = false;
                                      _eKYCController.selectStepKYC.value = StepKYC.three;

                                      // setState(() {
                                      //   selectedStep = 2;
                                      //   _kycVisible = false;
                                      //   _kycVisibleFalse = false;
                                      //   pathSelfie = '';
                                      // });
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ])
                  : SizedBox(),
        );
    }
  }

  Widget _buildWidgetStep(StepKYC e) {
    return Obx(() {
      var item;
      var checkItem = _eKYCController.processStepKYC.where((element) => element.select == e).isNotEmpty;
      if (checkItem) {
        item = _eKYCController.processStepKYC.firstWhere((p0) => p0.select == e);
      }
      return !checkItem
          ? _buildUnselectedStep()
          : !item.statusDone
              ? _buildSelectedStep(e)
              : _buildDoneStep();
    });
  }

  Widget _buildSelectedStep(StepKYC e) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromRGBO(2, 65, 109, 1),
          Color.fromRGBO(16, 107, 171, 1),
        ]),
      ),
      child: Center(
        child: Text(
          Format.numberStepKYC(e),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDoneStep() {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromRGBO(2, 65, 109, 1),
          Color.fromRGBO(16, 107, 171, 1),
        ]),
      ),
      child: const Center(child: Icon(Icons.check, color: Colors.white, size: 16)),
    );
  }

  Widget _buildUnselectedStep() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1, color: const Color.fromRGBO(2, 65, 109, 1)),
        color: Colors.white,
      ),
    );
  }
}
