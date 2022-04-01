import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:gb_e_kyc/getController/kyc_controller.dart';
import 'package:gb_e_kyc/widgets/pageLoading.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class KYCWidget extends StatefulWidget {
  const KYCWidget({Key? key}) : super(key: key);

  @override
  State<KYCWidget> createState() => _KYCWidgetState();
}

class _KYCWidgetState extends State<KYCWidget> {
  final _kycController = Get.find<KYCController>();
  final _infoController = Get.find<InformationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _kycController.isLoading.value
          ? pageLoading()
          : _kycController.detailKYCWidget.value
              ? Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'scanface'.tr,
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'scanface_verify'.tr,
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Row(children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF27AE60),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'photolight'.tr,
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ]),
                        Row(children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF27AE60),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'faceposition'.tr,
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ]),
                        SizedBox(height: 10),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [Image.asset('assets/images/FaceScan-1.jpg', scale: 5), Text('Keep_your_face_straight'.tr, textAlign: TextAlign.center)]),
                        SizedBox(width: 20),
                        Column(children: [Image.asset('assets/images/FaceScan-2.jpg', scale: 5), Text('Shoot_in_a_well_lit_area'.tr, textAlign: TextAlign.center)])
                      ],
                    ),
                  ]),
                )
              : Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: ListView(physics: ClampingScrollPhysics(), padding: EdgeInsets.all(20), children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _infoController.pathSelfie.value == ''
                          ? Image.asset(
                              'assets/icons/idCardD.png',
                              height: 300,
                              // fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_infoController.pathSelfie.value),
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 10),
                    Row(children: [
                      Icon(Icons.error_outline_outlined),
                      SizedBox(width: 5),
                      Text(
                        "Make_sure_your_id_card_is_clear_and_without_a_scratch".tr,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]),
                  ]),
                );
    });
  }
}
