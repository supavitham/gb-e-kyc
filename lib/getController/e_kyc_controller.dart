import 'package:get/get.dart';

enum StepKYC {
  one,
  two,
  three,
  four,
  five
}

class SelectStepKYC {
  late StepKYC select;
  late bool statusDone;

  @override
  String toString() {
    return 'SelectStepKYC{select: $select, statusDone: $statusDone}';
  }
}

class EKYCController extends GetxController{
    var selectStepKYC = StepKYC.one.obs;
    var processStepKYC = <SelectStepKYC>[].obs;

    @override
    void onInit() {
      SelectStepKYC newSelectStepKYC = SelectStepKYC();
      newSelectStepKYC.select = StepKYC.one;
      newSelectStepKYC.statusDone = false;
      processStepKYC.add(newSelectStepKYC);

      super.onInit();
    }
}