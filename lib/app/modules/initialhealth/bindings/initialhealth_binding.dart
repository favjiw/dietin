import 'package:dietin/app/services/UserService.dart';
import 'package:get/get.dart';

import '../controllers/initialhealth_controller.dart';

class InitialhealthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InitialhealthController>(
      () => InitialhealthController(),
    );
    Get.lazyPut<UserServices>(
          () => UserServices(),
    );
  }
}
