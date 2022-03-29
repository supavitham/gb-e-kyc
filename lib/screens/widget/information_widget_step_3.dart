import 'package:flutter/material.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/getController/information_controller.dart';
import 'package:gb_e_kyc/screens/widget/personalInfo.dart';
import 'package:get/get.dart';

class InformationWidget extends StatefulWidget {
  const InformationWidget({Key? key}) : super(key: key);

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  final _eKYCController = Get.find<EKYCController>();
  final _infoController = Get.find<InformationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _infoController.acceptScanCardIDWidget.value
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'idcard'.tr,
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'idcard_security'.tr,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('suggestion'.tr, style: TextStyle(fontSize: 20)),
                      _buildSuggestion('photolight'.tr),
                      _buildSuggestion('photoandIDcard_info'.tr),
                      _buildSuggestion('photoandIDcard_glare'.tr),
                      _buildSuggestion('idcard_official'.tr),
                    ]),
                  ),
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'idcard_policy'.tr,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
          : PersonalInfo(
              ocrAllFailed: _infoController.ocrFailedAll.value,
              person: _infoController.personalInfo.value,
              // setDataVisible: _infoController.setDataVisible,
              setnextStepKYC: _infoController.verifyStepInfo,
              // setIndex: _infoController.setSelectedStep,
              setFirstName: _infoController.setFirstName,
              setLastName: _infoController.setLastName,
              setAddress: _infoController.setAddress,
              // setAddressSearch: _infoController.setAddressSearch,
              setBirthday: _infoController.setBirthday,
              setIDCard: _infoController.setIDCard,
              setLaserCode: _infoController.setLaserCode,
              setCareerID: _infoController.setCareerID,
              setWorkName: _infoController.setWorkName,
              setWorkAddress: _infoController.setWorkAddress,
              setWorkAddressSearch: _infoController.setWorkAddressSearch,
              setindexDistric: _infoController.setindexDistric,
              setindexSubDistric: _infoController.setindexSubDistric,
              setindexProvince: _infoController.setindexProvince,
              setFileFrontCitizen: _infoController.setFileFrontCitizen,
              setFileBackCitizen: _infoController.setFileBackCitizen,
              setFileSelfie: _infoController.setFileSelfie,
            );
    });
  }

  Widget _buildSuggestion(String topic) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Icon(Icons.check_circle_outline_rounded, color: Color(0xFF02416D), size: 24),
      Text(topic, style: TextStyle(color: Colors.black54, fontSize: 16)),
    ]);
  }
}
