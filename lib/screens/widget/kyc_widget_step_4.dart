import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return _kycController.isLoading.value ? pageLoading() :
      Container(
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
              Column(children: [
                Image.asset('assets/images/FaceScan-1.jpg', scale: 5),
                Text('Keep_your_face_straight'.tr, textAlign: TextAlign.center)
              ]),
              SizedBox(width: 20),
              Column(children: [
                Image.asset('assets/images/FaceScan-2.jpg', scale: 5),
                Text('Shoot_in_a_well_lit_area'.tr, textAlign: TextAlign.center)
              ])
            ],
          ),
        ]),
      );
    });
  }
}
