import 'package:flutter/material.dart';
import 'package:gb_e_kyc/screens/e_kyc_screen.dart';
import 'package:get/get.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () => Get.to(EKYCScreen()),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.indigo,
            ),
            padding: EdgeInsets.all(8),
            child: Center(
              child: Text("E-KYC"),
            ),
          ),
        )
      ],
    );
  }
}
