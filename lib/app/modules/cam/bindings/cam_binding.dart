import 'package:get/get.dart';

import '../controllers/cam_controller.dart';

class CamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CamController>(
      () => CamController(),
    );
  }
}
