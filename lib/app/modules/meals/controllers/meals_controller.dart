import 'dart:async';
import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/services/FoodService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealsController extends GetxController {
  TextEditingController searchController = TextEditingController();

  var isLoading = true.obs; 
  var foodList = <FoodModel>[].obs;
  var filteredList = <FoodModel>[].obs;

  StreamSubscription? _foodSubscription;

  @override
  void onInit() {
    super.onInit();
    
    bindFoodStream();

    
    searchController.addListener(() {
      filterFoods(searchController.text);
    });
  }

  void bindFoodStream() {
    isLoading.value = true;

    
    _foodSubscription = FoodService.to.getAllFoodsStream().listen((foods) {
      
      foodList.assignAll(foods);

      
      filterFoods(searchController.text);

      
      if (isLoading.value) isLoading.value = false;

      print('[MealsController] Data makanan diperbarui dari stream: ${foods.length} items');
    }, onError: (error) {
      print('[MealsController] Stream error: $error');
      
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
    
    _foodSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}