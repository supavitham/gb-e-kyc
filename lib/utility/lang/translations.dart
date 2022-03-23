import 'package:get/get.dart';

import 'en-EN.dart';
import 'th-TH.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_EN': en(), 'th_TH': th()};
}
