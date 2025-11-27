import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/modules/home/controllers/home_controller.dart'; // Import HomeController
import 'package:dietin/app/services/FoodLogService.dart';
import 'package:dietin/app/services/FoodService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SearchFoodController extends GetxController {
  TextEditingController searchController = TextEditingController();

  var isLoading = false.obs;
  var isSubmitting = false.obs;

  // Data makanan dari API
  var allFoods = <FoodModel>[].obs;
  var filteredFoods = <FoodModel>[].obs;

  // State seleksi: Map foodId -> isSelected
  var selectedItems = <int, bool>{}.obs;

  // Data dari argumen navigasi
  late String mealType;
  late String date;

  @override
  void onInit() {
    super.onInit();

    // Ambil argumen dari HomeView
    final args = Get.arguments as Map<String, dynamic>?;
    mealType = args?['mealType'] ?? 'Breakfast'; // Default fallback
    date = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Hari ini

    print('[SearchFood] Adding for $mealType on $date');

    fetchFoods();

    // Listener pencarian
    searchController.addListener(() {
      filterFoods(searchController.text);
    });
  }

  Future<void> fetchFoods() async {
    try {
      isLoading.value = true;
      // Menggunakan FoodService yang sudah ada
      final foods = await FoodService.to.getAllFoods();
      allFoods.assignAll(foods);
      filteredFoods.assignAll(foods);

      // Inisialisasi status seleksi
      selectedItems.clear();
      for (var food in foods) {
        selectedItems[food.id] = false;
      }

    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data makanan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterFoods(String query) {
    if (query.isEmpty) {
      filteredFoods.assignAll(allFoods);
    } else {
      filteredFoods.assignAll(
          allFoods.where((food) =>
              food.name.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }

  void toggleSelection(int foodId) {
    if (selectedItems.containsKey(foodId)) {
      // Toggle nilai bool yang ada
      selectedItems[foodId] = !(selectedItems[foodId]!);
    } else {
      // Jika belum ada di map (kasus jarang jika inisialisasi benar), set true
      selectedItems[foodId] = true;
    }

    // Trigger update UI manual untuk RxMap jika perubahan tidak terdeteksi
    // (Meskipun RxMap harusnya otomatis, kadang perlu refresh di nested/complex UI)
    // Namun, Obx di view harus membungkus widget yang menggunakan selectedItems
  }

  // Cek status seleksi helper
  bool isSelected(int foodId) => selectedItems[foodId] ?? false;

  // Hitung jumlah item yang dipilih
  int get selectedCount => selectedItems.values.where((e) => e).length;

  Future<void> submitLog() async {
    final selectedIds = selectedItems.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedIds.isEmpty) {
      Get.snackbar('Peringatan', 'Pilih setidaknya satu makanan');
      return;
    }

    try {
      isSubmitting.value = true;

      // Persiapkan payload
      // Default servings 1.0 karena belum ada UI input servings di list
      final foodsPayload = selectedIds.map((id) => {
        "foodId": id,
        "servings": 1.0
      }).toList();

      await FoodLogService.to.logFood(
        date: date,
        mealType: mealType,
        foods: foodsPayload,
      );

      Get.snackbar(
        'Sukses',
        'Berhasil mencatat ${selectedIds.length} makanan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Refresh Home Controller agar data terbaru muncul
      // Kita cari controller Home jika masih ada di stack
      if (Get.isRegistered<HomeController>()) {
        print('[SearchFood] Refreshing Home Data...');
        await Get.find<HomeController>().loadDashboardData();
      } else {
        print('[SearchFood] HomeController not found!');
      }

      Get.back(); // Kembali ke Home

    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan log: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}