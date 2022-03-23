import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb_e_kyc/screens/e_kyc_screen.dart';
import 'package:gb_e_kyc/utility/lang/translations.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GB E-KYC',
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('th', 'TH'),
      debugShowCheckedModeBanner: false,
      home: const EKYCScreen(),
      theme:  ThemeData(
        primaryColor: const Color(0xFF02416D),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        unselectedWidgetColor: const Color(0xFF00598A),
        fontFamily: 'Kanit',
        dividerTheme: const DividerThemeData(color: Colors.grey, space: 0),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'kanit'),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        buttonTheme: ButtonThemeData(
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textTheme: ButtonTextTheme.accent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF02416D), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF02416D)),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
          hintStyle: const TextStyle(color: Colors.grey),
          counterStyle: const TextStyle(fontSize: 0),
        ),
        textTheme: const TextTheme(button: TextStyle(fontSize: 17)),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF02416D),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),

    );
  }
}