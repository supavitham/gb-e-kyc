import 'package:flutter/material.dart';
import 'package:gb_e_kyc/getController/e_kyc_controller.dart';
import 'package:gb_e_kyc/screens/widget/phone_number_step_1.dart';
import 'package:gb_e_kyc/utility/format.dart';
import 'package:gb_e_kyc/widgets/buttonCancel.dart';
import 'package:gb_e_kyc/widgets/buttonConfirm.dart';
import 'package:get/get.dart';

class EKYCScreen extends StatefulWidget {
  const EKYCScreen({Key? key}) : super(key: key);

  @override
  State<EKYCScreen> createState() => _EKYCScreenState();
}

class _EKYCScreenState extends State<EKYCScreen> {
  final _eKYCController = Get.put(EKYCController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'register'.tr,
            style: const TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            onPressed: () {},
            color: Colors.black,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              height: 80,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: const Divider(
                    color: Color(0xFF02416D),
                    thickness: 1.5,
                    height: 30,
                    indent: 30,
                    endIndent: 20,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: StepKYC.values
                      .map((e) => Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 33,
                                  child: _buildWidgetStep(e),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                    child: Text(
                                  Format.nameStepKYC(e),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                )),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ]),
            ),
          ),
        ),
        body: Obx(() {
          var step = _eKYCController.selectStepKYC.value;
          switch (step) {
            case StepKYC.one:
              return const PhoneNumberWidget();
            case StepKYC.two:
              return const PhoneNumberWidget();
            case StepKYC.three:
              return const PhoneNumberWidget();
            case StepKYC.four:
              return const PhoneNumberWidget();
            case StepKYC.five:
              return const PhoneNumberWidget();
          }
        }),
        bottomNavigationBar: Obx(() {
          var step = _eKYCController.selectStepKYC.value;
          return selectBottomView(step);
        }),
      ),
    );
  }

  selectBottomView(StepKYC step) {
    switch (step) {
      case StepKYC.one:
        return  Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
          child: Row(children: [
            Expanded(
              child: ButtonCancel(
                text: 'back'.tr,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ButtonConfirm(
                text: 'continue'.tr,
                onPressed: () async {
                  //await autoSubmitPhoneNumber();
                },
              ),
            )
          ]),
        );
      case StepKYC.two:
        return "OTP";
      case StepKYC.three:
        return "data";
      case StepKYC.four:
        return "pin";
      case StepKYC.five:
        return "KYC";
    }
  }

  Widget _buildWidgetStep(StepKYC e) {
    return Obx(() {
      var item;
      var checkItem = _eKYCController.processStepKYC
          .where((element) => element.select == e)
          .isNotEmpty;
      if (checkItem) {
        item =
            _eKYCController.processStepKYC.firstWhere((p0) => p0.select == e);
      }
      return !checkItem
          ? _buildUnselectedStep()
          : !item.statusDone
              ? _buildSelectedStep()
              : _buildDoneStep();
    });
  }

  Widget _buildSelectedStep() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromRGBO(2, 65, 109, 1),
          Color.fromRGBO(16, 107, 171, 1),
        ]),
      ),
      child: const Center(
        child: Text(
          "1",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDoneStep() {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromRGBO(2, 65, 109, 1),
          Color.fromRGBO(16, 107, 171, 1),
        ]),
      ),
      child:
          const Center(child: Icon(Icons.check, color: Colors.white, size: 16)),
    );
  }

  Widget _buildUnselectedStep() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(width: 1, color: const Color.fromRGBO(2, 65, 109, 1)),
        color: Colors.white,
      ),
    );
  }
}
