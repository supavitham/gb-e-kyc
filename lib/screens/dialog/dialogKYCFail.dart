import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:gb_e_kyc/getController/kyc_controller.dart';
import 'package:gb_e_kyc/utility/fileUitility.dart';
import 'package:gb_e_kyc/widgets/cameraScanIDCard.dart';
import 'package:gb_e_kyc/widgets/dialog/deleteDialog.dart';
import 'package:get/get.dart';

class DialogKYCFail extends StatelessWidget {
  final _infoController = Get.put(InformationController());
  final _kycController = Get.put(KYCController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(alignment: Alignment.topCenter, children: [
        Container(
          margin: EdgeInsets.only(top: 30, left: 10, right: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'liveness_is_unsuccessful'.tr,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Image.asset('assets/icons/idCardD.png', width: 113, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(
              'Selfie_with_ID_cardMake_sure'.tr,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    child:  MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScanIDCard(
                              titleAppbar: 'Selfie_ID_Card'.tr,
                              enableButton: true,
                              isFront: true,
                              noFrame: true,
                            ),
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
                                Navigator.pop(context);
                                // _kycVisible = false;
                                // _kycVisibleFalse = true;
                                _infoController.pathSelfie.value = v;
                                _kycController.detailKYCWidget.value = false;
                              }
                            }
                          },
                        );
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
              ]),
            )
          ]),
        ),
        CircleAvatar(
          child: Image.asset('assets/images/Close.png', height: 48, width: 48),
          maxRadius: 32,
          backgroundColor: Colors.white,
        ),
      ]),
    );
  }
}
