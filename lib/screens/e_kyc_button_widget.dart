import 'package:flutter/material.dart';
import 'package:gb_e_kyc/screens/e_kyc_screen.dart';

class EKYCButtonWidget extends StatefulWidget {
  const EKYCButtonWidget({Key? key}) : super(key: key);

  @override
  State<EKYCButtonWidget> createState() => _EKYCButtonWidgetState();
}

class _EKYCButtonWidgetState extends State<EKYCButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EKYCScreen())),
      child: Container(
        // width: 60,
        // height: 80,
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "KYC",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black
            ),
          ),
        ),
      ),
    );
  }
}
