import 'dart:async';
import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/services/FoodService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealsController extends GetxController {
  TextEditingController searchController = TextEditingController();

  var isLoading = true.obs; // Awalnya true karena menunggu stream pertama
  var foodList = <FoodModel>[].obs;
  var filteredList = <FoodModel>[].obs;

  StreamSubscription? _foodSubscription;

  @override
  void onInit() {
    super.onInit();
    // Mulai stream makanan
    bindFoodStream();

    // Listener untuk pencarian real-time
    searchController.addListener(() {
      filterFoods(searchController.text);
    });
  }

  void bindFoodStream() {
    isLoading.value = true;

    // Menggunakan getAllFoodsStream dari service
    _foodSubscription = FoodService.to.getAllFoodsStream().listen((foods) {
      // Update data master
      foodList.assignAll(foods);

      // Terapkan filter yang sedang aktif (jika ada query pencarian)
      filterFoods(searchController.text);

      // Matikan loading setelah data pertama diterima
      if (isLoading.value) isLoading.value = false;

      print('[MealsController] Data makanan diperbarui dari stream: ${foods.length} items');
    }, onError: (error) {
      print('[MealsController] Stream error: $error');
      // Opsional: Tampilkan snackbar error, tapi hati-hati agar tidak spamming karena ini stream
      isLoading.value = false;
    });
  }

  void filterFoods(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(foodList);
    } else {
      filteredList.assignAll(
          foodList.where((food) =>
              food.name.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }

  @override
  void onClose() {
    // Penting: Batalkan subscription stream saat controller ditutup untuk mencegah memory leak
    _foodSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}