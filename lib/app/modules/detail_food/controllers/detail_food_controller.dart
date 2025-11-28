import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/services/FoodService.dart';
import 'package:get/get.dart';

class DetailFoodController extends GetxController {
  var isFavorite = false.obs;
  var isLoading = true.obs;
  var food = Rxn<FoodModel>();

  @override
  void onInit() {
    super.onInit();
    _loadFoodDetail();
  }

  void _loadFoodDetail() async {
    isLoading.value = true;

    if (Get.arguments != null) {
      if (Get.arguments is FoodModel) {
        food.value = Get.arguments as FoodModel;
        isLoading.value = false;

        _fetchFoodById(food.value!.id);
      }
      else if (Get.arguments is int) {
        await _fetchFoodById(Get.arguments as int);
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Error", "Data makanan tidak ditemukan");
    }
  }

  Future<void> _fetchFoodById(int id) async {
    try {
      final fetchedFood = await FoodService.to.getFoodById(id);
      if (fetchedFood != null) {
        food.value = fetchedFood;
      }
    } catch (e) {
      print("Error loading food detail: $e");
      if (food.value == null) { 
        Get.snackbar("Error", "Gagal memuat detail makanan");
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
}