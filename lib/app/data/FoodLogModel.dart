import 'FoodModel.dart';

class FoodLogModel {
  final int id;
  // final int userId; // Backend response tidak selalu mengirim userId di list, bisa di-nullable-kan atau default 0
  final String date;
  final String mealType;
  final int totalCalories; // Backend tidak mengirim ini di root object log, kita harus hitung atau default 0
  final List<FoodLogItemModel> items;

  FoodLogModel({
    required this.id,
    // required this.userId,
    required this.date,
    required this.mealType,
    required this.totalCalories,
    required this.items,
  });

  factory FoodLogModel.fromJson(Map<String, dynamic> json) {
    // Parsing list 'foods' dari backend
    var listFoods = json['foods'] as List<dynamic>? ?? [];

    // Mapping ke FoodLogItemModel
    List<FoodLogItemModel> parsedItems = listFoods.map((itemJson) {
      // itemJson di sini adalah struktur makanan lengkap dari backend
      // Kita anggap ini sebagai 'FoodLogItem' yang membungkus 'Food'
      return FoodLogItemModel.fromFoodJson(itemJson);
    }).toList();

    // Hitung total kalori manual jika backend tidak menyediakannya di level root
    // Backend Anda tidak mengirim 'totalCalories' di level log object, jadi kita hitung dari items
    int calculatedTotalCalories = parsedItems.fold(0, (sum, item) => sum + item.calories);

    return FoodLogModel(
      id: json['id'] ?? 0,
      // userId: json['userId'] ?? 0,
      date: json['date'] ?? '',
      mealType: json['mealType'] ?? '',
      totalCalories: calculatedTotalCalories, // Gunakan hasil hitungan
      items: parsedItems,
    );
  }
}

class FoodLogItemModel {
  final int id; // ID dari log item, mungkin tidak ada di struktur flat backend, pakai ID makanan atau generate
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

  // Factory khusus untuk menangani struktur flat dari backend 'foods' array
  factory FoodLogItemModel.fromFoodJson(Map<String, dynamic> json) {
    // Buat objek FoodModel dari json yang sama
    final foodModel = FoodModel.fromJson(json);

    // Ambil servings dari json (karena ada di level makanan di response log ini)
    final servings = (json['servings'] is int)
        ? (json['servings'] as int).toDouble()
        : (json['servings'] as double? ?? 1.0);

    // Cari nilai kalori dari nutritionFacts untuk properti calories di level item
    int cal = 0;
    if (foodModel.nutritionFacts.isNotEmpty) {
      final fact = foodModel.nutritionFacts.firstWhere(
            (f) => f.name.toLowerCase().contains('kalori'),
        orElse: () => NutritionFactModel(name: '', value: '0'),
      );
      final cleanVal = fact.value.replaceAll(RegExp(r'[^0-9]'), ''); // Ambil angka saja
      cal = int.tryParse(cleanVal) ?? 0;
    }

    // Sesuaikan kalori dengan porsi
    // Asumsi: Nutrisi di foodModel adalah per 1 porsi
    int totalCal = (cal * servings).round();

    return FoodLogItemModel(
      id: json['id'] ?? 0, // Gunakan ID makanan sebagai ID item sementara
      foodId: foodModel.id,
      servings: servings,
      calories: totalCal,
      food: foodModel,
    );
  }

  // Factory standar untuk backward compatibility jika struktur berubah
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