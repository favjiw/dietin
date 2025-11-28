// ignore_for_file: file_names

class FoodModel {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int? prepTime;
  final int? cookTime;
  final int? servings;
  final String? servingType; 
  final List<StepModel> steps;
  final List<NutritionFactModel> nutritionFacts;
  final List<IngredientModel> ingredients;

  FoodModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.prepTime,
    this.cookTime,
    this.servings,
    this.servingType, 
    this.steps = const [],
    this.nutritionFacts = const [],
    this.ingredients = const [],
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      servings: json['servings'],
      servingType: json['servingType'], 
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => StepModel.fromJson(e))
          .toList() ??
          [],
      nutritionFacts: (json['nutritionFacts'] as List<dynamic>?)
          ?.map((e) => NutritionFactModel.fromJson(e))
          .toList() ??
          [],
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  
  String get calories {
    final fact = nutritionFacts.firstWhere(
          (element) => element.name.toLowerCase().contains('kalori'),
      orElse: () => NutritionFactModel(name: '', value: '-'),
    );
    return fact.value;
  }
}

class StepModel {
  final String title;
  final List<String> substeps;

  StepModel({required this.title, required this.substeps});

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      title: json['title'] ?? '',
      substeps: (json['substeps'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}

class NutritionFactModel {
  final String name;
  final String value;

  NutritionFactModel({required this.name, required this.value});

  factory NutritionFactModel.fromJson(Map<String, dynamic> json) {
    return NutritionFactModel(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class IngredientModel {
  final String name;
  final String quantity;

  IngredientModel({required this.name, required this.quantity});

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
}