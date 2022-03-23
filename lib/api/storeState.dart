import 'package:get/get_rx/src/rx_types/rx_types.dart';

class StoreState {
  static RxString deviceSerial = ''.obs;
  static RxString fcmToken = ''.obs;
  static RxString token = ''.obs;
  static RxString pin = ''.obs;
  static RxString role = ''.obs;
  static RxString lastLoginAt = ''.obs;
  static RxBool approve = false.obs;
  static RxList recentSearch = [].obs;
  static RxList recentRedeemed = [].obs;
}
