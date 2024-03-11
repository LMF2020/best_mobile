import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';

import '../api/http_api.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HttpsAPI());
  }
}
