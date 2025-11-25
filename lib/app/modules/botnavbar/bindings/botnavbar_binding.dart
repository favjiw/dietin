import 'package:dietin/app/modules/home/controllers/home_controller.dart';
import 'package:dietin/app/modules/meals/controllers/meals_controller.dart';
import 'package:dietin/app/modules/profile/controllers/profile_controller.dart';
import 'package:dietin/app/modules/statistics/controllers/statistics_controller.dart';
import 'package:dietin/app/modules/botnavbar/controllers/botnavbar_controller.dart';
import 'package:dietin/app/services/UserService.dart';
import 'package:get/get.dart';

class BotnavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserServices>(
          () => UserServices(),
      fenix: true,
    );

    // Controller tab dan botnav
    Get.lazyPut<BotnavbarController>(() => BotnavbarController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<MealsController>(() => MealsController(), fenix: true);
    Get.lazyPut<StatisticsController>(() => StatisticsController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
