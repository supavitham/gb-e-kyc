import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Format {
  Format();

  static String nameStepKYC(StepKYC item) {
    switch (item) {
      case StepKYC.one:
        return "phone_number";
      case StepKYC.two:
        return "OTP";
      case StepKYC.three:
        return "data";
      case StepKYC.four:
        return "KYC";
    }
  }

  static String numberStepKYC(StepKYC item) {
    switch (item) {
      case StepKYC.one:
        return "1";
      case StepKYC.two:
        return "2";
      case StepKYC.three:
        return "3";
      case StepKYC.four:
        return "4";
    }
  }

  static MaskTextInputFormatter phoneNumber = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
}
