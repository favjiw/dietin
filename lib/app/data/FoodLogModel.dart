// ignore_for_file: file_names
import 'FoodModel.dart';

class FoodLogModel {
  final int id;
  final String date;
  final String mealType;
  final int totalCalories; 
  final List<FoodLogItemModel> items;

  FoodLogModel({
    required this.id,
    required this.date,
    required this.mealType,
    required this.totalCalories,
    required this.items,
  });

  factory FoodLogModel.fromJson(Map<String, dynamic> json) {
    var listFoods = json['foods'] as List<dynamic>? ?? [];
    List<FoodLogItemModel> parsedItems = listFoods.map((itemJson) {
      return FoodLogItemModel.fromFoodJson(itemJson);
    }).toList();
    
    int calculatedTotalCalories = parsedItems.fold(0, (sum, item) => sum + item.calories);

    return FoodLogModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      mealType: json['mealType'] ?? '',
      totalCalories: calculatedTotalCalories, 
      items: parsedItems,
    );
  }
}

class FoodLogItemModel {
  final int id; 
  final int foodId;
  final double servings;
  final int calories;
  final FoodModel? food;

  FoodLogItemModel({
    required this.id,
    required this.foodId,
    required this.servings,
    required this.calories,
    this.food,
  });

  
  factory FoodLogItemModel.fromFoodJson(Map<String, dynamic> json) {
    
    final foodModel = FoodModel.fromJson(json);

    
    final servings = (json['servings'] is int)
        ? (json['servings'] as int).toDouble()
        : (json['servings'] as double? ?? 1.0);

    int cal = 0;
    if (foodModel.nutritionFacts.isNotEmpty) {
      final fact = foodModel.nutritionFacts.firstWhere(
            (f) => f.name.toLowerCase().contains('kalori'),
        orElse: () => NutritionFactModel(name: '', value: '0'),
      );
      final cleanVal = fact.value.replaceAll(RegExp(r'[^0-9]'), ''); 
      cal = int.tryParse(cleanVal) ?? 0;
    }
    
    int totalCal = (cal * servings).round();

    return FoodLogItemModel(
      id: json['id'] ?? 0, 
      foodId: foodModel.id,
      servings: servings,
      calories: totalCal,
      food: foodModel,
    );
  }

  factory FoodLogItemModel.fromJson(Map<String, dynamic> json) {
    return FoodLogItemModel(
      id: json['id'] ?? 0,
      foodId: json['foodId'] ?? 0,
      servings: (json['servings'] is int) ? (json['servings'] as int).toDouble() : (json['servings'] ?? 1.0),
      calories: json['calories'] ?? 0,
      food: json['food'] != null ? FoodModel.fromJson(json['food']) : null,
    );
  }
}