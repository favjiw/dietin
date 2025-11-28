import 'package:dietin/app/services/FoodLogService.dart';
import 'package:dietin/app/services/FoodService.dart';
import 'package:get/get.dart';

import '../controllers/search_food_controller.dart';

class SearchFoodBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FoodService>()) {
      Get.lazyPut<FoodService>(() => FoodService());
    }

    Get.lazyPut<FoodLogService>(() => FoodLogService());

    Get.lazyPut<SearchFoodController>(
          () => SearchFoodController(),
    );
  }
}