import 'package:dietin/app/services/FoodLogService.dart';
import 'package:dietin/app/services/FoodService.dart';
import 'package:get/get.dart';

import '../controllers/search_food_controller.dart';

class SearchFoodBinding extends Bindings {
  @override
  void dependencies() {
    // Pastikan FoodService tersedia (biasanya sudah ada dari BotnavbarBinding, tapi aman untuk put jika perlu)
    if (!Get.isRegistered<FoodService>()) {
      Get.lazyPut<FoodService>(() => FoodService());
    }

    // Register FoodLogService
    Get.lazyPut<FoodLogService>(() => FoodLogService());

    Get.lazyPut<SearchFoodController>(
          () => SearchFoodController(),
    );
  }
}