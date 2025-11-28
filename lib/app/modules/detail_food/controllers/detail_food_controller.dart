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

    // Cek apakah ada argumen yang dikirim dari halaman sebelumnya
    if (Get.arguments != null) {
      // Jika argumen adalah FoodModel object (dari list yang sudah diload)
      if (Get.arguments is FoodModel) {
        food.value = Get.arguments as FoodModel;
        isLoading.value = false;

        // Opsional: Tetap fetch ulang untuk memastikan data terbaru (misal stok/detail lain)
        _fetchFoodById(food.value!.id);
      }
      // Jika argumen hanya ID (misal dari deep link atau notifikasi)
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
      if (food.value == null) { // Hanya tampilkan error jika data belum ada sama sekali
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