import 'package:dietin/app/data/FoodLogModel.dart';
import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/services/FoodLogService.dart';
import 'package:dietin/app/services/UserService.dart';
import 'package:dietin/app/data/UserModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var errorMessage = ''.obs;

  // Log Makanan (Sekarang akan berisi gabungan item)
  var breakfastLog = Rxn<FoodLogModel>();
  var lunchLog = Rxn<FoodLogModel>();
  var dinnerLog = Rxn<FoodLogModel>();

  // Nutrisi Harian
  var totalCaloriesConsumed = 0.obs;
  var totalCarbsConsumed = 0.obs;
  var totalProteinConsumed = 0.obs;
  var totalFatConsumed = 0.obs;

  // Target (Dummy)
  final targetCalories = 2000;
  final targetCarbs = 300;
  final targetProtein = 100;
  final targetFat = 70;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await fetchUser();
      await fetchDailyLogs();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUser() async {
    try {
      errorMessage.value = '';
      final data = await UserServices.to.fetchUserProfile();
      user.value = UserModel.fromJson(data);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> fetchDailyLogs() async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final logs = await FoodLogService.to.getFoodLogsByDate(today);

      // Reset data
      breakfastLog.value = null;
      lunchLog.value = null;
      dinnerLog.value = null;

      int calcCalories = 0;
      double calcCarbs = 0;
      double calcProtein = 0;
      double calcFat = 0;

      // Temporary lists untuk menampung item gabungan
      List<FoodLogItemModel> breakfastItems = [];
      List<FoodLogItemModel> lunchItems = [];
      List<FoodLogItemModel> dinnerItems = [];

      if (logs.isNotEmpty) {
        for (var log in logs) {
          // Kumpulkan item ke list sementara berdasarkan mealType
          switch (log.mealType) {
            case 'Breakfast':
              breakfastItems.addAll(log.items);
              break;
            case 'Lunch':
              lunchItems.addAll(log.items);
              break;
            case 'Dinner':
              dinnerItems.addAll(log.items);
              break;
          }

          // Hitung nutrisi (tetap sama logikanya)
          for (var item in log.items) {
            calcCalories += item.calories;

            if (item.food != null && item.food!.nutritionFacts.isNotEmpty) {
              double getVal(List<String> keys) => _findNutrientValue(item.food!.nutritionFacts, keys);

              final carbs = getVal(['Karbohidrat', 'Carbohydrate', 'Carbs', 'Karbo']);
              final protein = getVal(['Protein']);
              final fat = getVal(['Lemak', 'Fat']);

              calcCarbs += (carbs * item.servings);
              calcProtein += (protein * item.servings);
              calcFat += (fat * item.servings);
            }
          }
        }
      }

      // Buat FoodLogModel gabungan untuk ditampilkan di UI
      // Kita pakai tanggal hari ini dan ID dummy karena ini adalah agregasi
      if (breakfastItems.isNotEmpty) {
        breakfastLog.value = FoodLogModel(
          id: 0, // Dummy ID
          date: today,
          mealType: 'Breakfast',
          totalCalories: 0, // Tidak dipakai di UI (dihitung manual di view), atau bisa dihitung di sini
          items: breakfastItems,
          // userId: 0,
        );
      }

      if (lunchItems.isNotEmpty) {
        lunchLog.value = FoodLogModel(
          id: 0,
          date: today,
          mealType: 'Lunch',
          totalCalories: 0,
          items: lunchItems,
          // userId: 0,
        );
      }

      if (dinnerItems.isNotEmpty) {
        dinnerLog.value = FoodLogModel(
          id: 0,
          date: today,
          mealType: 'Dinner',
          totalCalories: 0,
          items: dinnerItems,
          // userId: 0,
        );
      }

      // Update Observables Global
      totalCaloriesConsumed.value = calcCalories;
      totalCarbsConsumed.value = calcCarbs.round();
      totalProteinConsumed.value = calcProtein.round();
      totalFatConsumed.value = calcFat.round();

      print('[HomeController] Updated -> Cal: $calcCalories');

    } catch (e) {
      print('[HomeController] Error logs: $e');
    }
  }

  double _findNutrientValue(List<NutritionFactModel> facts, List<String> keys) {
    try {
      final fact = facts.firstWhere(
            (f) => keys.any((k) => f.name.toLowerCase().contains(k.toLowerCase())),
        orElse: () => NutritionFactModel(name: '', value: '0'),
      );
      String cleanValue = fact.value.replaceAll(RegExp(r'[^0-9.,]'), '');
      cleanValue = cleanValue.replaceAll(',', '.');
      return double.tryParse(cleanValue) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}