import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gb_e_kyc/bloc/addressBloc.dart';
import 'package:gb_e_kyc/screens/e_kyc_screen.dart';
import 'package:gb_e_kyc/screens/start_screen.dart';
import 'package:gb_e_kyc/utility/lang/translations.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "assets/.env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressBloc(),
      child: GetMaterialApp(
        title: 'GB E-KYC',
        builder: EasyLoading.init(),
        translations: Messages(),
        // locale: Get.deviceLocale,
        locale: Locale('th', 'TH'),
        fallbackLocale: const Locale('th', 'TH'),
        debugShowCheckedModeBanner: false,
        home: StartScreen(),
        theme: ThemeData(
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
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    // ..maskType = EasyLoadingMaskType.custom
    // ..maskColor = Colors.black.withOpacity(0.1)
    ..radius = 10
    ..contentPadding = const EdgeInsets.all(14)
    ..indicatorWidget = Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      child: const LoadingIndicator(
        indicatorType: Indicator.ballRotateChase,
        colors: [Color(0xFFFF9F02)],
        strokeWidth: 4,
      ),
    )
    ..userInteractions = false
    ..dismissOnTap = false;
}
