import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_e_kyc/api/post.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/widgets/timeOTP.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPWidget extends StatefulWidget {
  final TextEditingController cOTP;

  const OTPWidget({Key? key, required this.cOTP}) : super(key: key);

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  final _eKYCController = Get.find<EKYCController>();
  final _formKeyOTP = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _eKYCController.errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    _eKYCController.errorController.close();
    _formKeyOTP.currentState?.dispose();
    widget.cOTP.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'confirm_phone_num'.tr,
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            '${'enter_pin_sent_phone'.tr} ${_eKYCController.cPhoneNumber.text}',
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKeyOTP,
            child: PinCodeTextField(
              controller: widget.cOTP,
              autoDisposeControllers: false,
              appContext: context,
              pastedTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              obscureText: false,
              obscuringCharacter: '*',
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 43,
                activeColor: _eKYCController.hasErrorOTP.value ? Colors.red : Colors.white,
                selectedColor: const Color.fromRGBO(2, 65, 109, 1),
                inactiveColor: const Color.fromRGBO(2, 65, 109, 1),
                disabledColor: Colors.grey,
                activeFillColor: Colors.white,
                selectedFillColor: const Color.fromRGBO(2, 65, 109, 1),
                inactiveFillColor: Colors.white,
              ),
              cursorColor: Colors.white,
              animationDuration: const Duration(milliseconds: 300),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
              enableActiveFill: true,
              errorAnimationController: _eKYCController.errorController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              boxShadows: const [BoxShadow(offset: Offset(0, 1), color: Colors.black12, blurRadius: 10)],
              onChanged: (v) {
                _eKYCController.hasErrorOTP.value = false;
                if (v.length == 6) {
                  if (_formKeyOTP.currentState!.validate() && widget.cOTP.value.text.length == 6) {
                    _eKYCController.autoSubmitOTP(widget.cOTP.text);
                  } else {
                    _eKYCController.errorController.add(ErrorAnimationType.shake);
                    _eKYCController.hasErrorOTP.value = true;
                  }
                }
              },
              beforeTextPaste: (text) {
                return true;
              },
            ),
          ),
          timeOTP(
            expiration: _eKYCController.expiration.value,
            datetimeOTP: _eKYCController.datetimeOTP,
            onPressed: () async {
              String txPhoneNumber = _eKYCController.cPhoneNumber.text.replaceAll('-', '');
              String countryCode = _eKYCController.countryCode;

              var otpId = await PostAPI().sendOTP(phoneNumber: txPhoneNumber, countryCode: countryCode);

              if (otpId['success']) {
                _eKYCController.sendOtpId.value = otpId['response']['data']['send_otp_id'];
                _eKYCController.datetimeOTP = DateTime.parse(otpId['response']['data']['expiration_at']);
                widget.cOTP.clear();
                _eKYCController.expiration.value = false;
              }
            },
            onDone: () => _eKYCController.expiration.value = true,
          ),
        ],
      ),
    );
  }
}
