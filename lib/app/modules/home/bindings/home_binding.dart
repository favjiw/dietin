import 'package:dietin/app/services/UserService.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserServices>(
          () => UserServices(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
