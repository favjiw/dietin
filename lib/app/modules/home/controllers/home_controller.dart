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

  var breakfastLog = Rxn<FoodLogModel>();
  var lunchLog = Rxn<FoodLogModel>();
  var dinnerLog = Rxn<FoodLogModel>();

  var totalCaloriesConsumed = 0.obs;
  var totalCarbsConsumed = 0.obs;
  var totalProteinConsumed = 0.obs;
  var totalFatConsumed = 0.obs;

  
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

      breakfastLog.value = null;
      lunchLog.value = null;
      dinnerLog.value = null;

      int calcCalories = 0;
      double calcCarbs = 0;
      double calcProtein = 0;
      double calcFat = 0;

      List<FoodLogItemModel> breakfastItems = [];
      List<FoodLogItemModel> lunchItems = [];
      List<FoodLogItemModel> dinnerItems = [];

      if (logs.isNotEmpty) {
        for (var log in logs) {
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

      if (breakfastItems.isNotEmpty) {
        breakfastLog.value = FoodLogModel(
          id: 0, 
          date: today,
          mealType: 'Breakfast',
          totalCalories: 0, 
          items: breakfastItems,
        );
      }

      if (lunchItems.isNotEmpty) {
        lunchLog.value = FoodLogModel(
          id: 0,
          date: today,
          mealType: 'Lunch',
          totalCalories: 0,
          items: lunchItems,
        );
      }

      if (dinnerItems.isNotEmpty) {
        dinnerLog.value = FoodLogModel(
          id: 0,
          date: today,
          mealType: 'Dinner',
          totalCalories: 0,
          items: dinnerItems,
        );
      }

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