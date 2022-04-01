import 'package:flutter/material.dart';
import 'package:gb_e_kyc/screens/e_kyc_button_widget.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        EKYCButtonWidget(),
      ],
    );
  }
}
