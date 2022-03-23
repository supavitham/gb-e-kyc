import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/utility/format.dart';
import 'package:get/get.dart';

class PhoneNumberWidget extends StatefulWidget {
  const PhoneNumberWidget({Key? key}) : super(key: key);

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  final _eKYCController = Get.find<EKYCController>();

  final _formKeyPhoneNumber = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Form(
        key: _formKeyPhoneNumber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'register'.tr,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'enter_to_otp'.tr,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Column(children: [
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _eKYCController.cPhoneNumber,
                  maxLength: 12,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'please_enter'.tr;
                    } else if (v.length != 12) {
                      return 'pls_10digits'.tr;
                    }
                    return null;
                  },
                  onChanged: (v) async {
                    _formKeyPhoneNumber.currentState!.validate();
                    if (v.length == 12) {
                      FocusScope.of(context).unfocus();
                      if(_formKeyPhoneNumber.currentState!.validate() && _eKYCController.cPhoneNumber.text.length == 12){
                        await _eKYCController.autoSubmitPhoneNumber();
                      }
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'phone_num'.tr,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[Format.phoneNumber],
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
