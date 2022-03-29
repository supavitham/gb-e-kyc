import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget pageLoading({String? title}) {
  return Scaffold(
    body: Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/logo_home.jpg', height: 160, width: 180),
          Text(
            title ?? 'System_is_processing'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'sub_slogan'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: SizedBox(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: const [Color(0xFFFF9F02)],
                strokeWidth: 4,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.white,
              ),
            ),
          ),
        ]),
      ),
    ),
  );
}
