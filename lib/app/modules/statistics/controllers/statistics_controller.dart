import 'package:dietin/app/data/FoodLogModel.dart';
import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/data/UserModel.dart';
import 'package:dietin/app/services/FoodLogService.dart';
import 'package:dietin/app/services/UserService.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 

class StatisticsController extends GetxController {
  var isLoading = false.obs;

  
  final selectedTab = 0.obs; 
  final selectedNutrient = 'Kalori'.obs;
  final touchedIndex = (-1).obs;
  final selectedDayIndex = (-1).obs;

  
  final selectedMonth = ''.obs;
  final selectedYear = DateTime.now().year.toString().obs;

  final currentDateRangeIndex = 0.obs;

  
  
  var allLogs = <FoodLogModel>[].obs;

  
  var user = Rxn<UserModel>();
  var bmiValue = 0.0.obs;
  var bmiStatus = ''.obs;

  
  final List<String> nutrients = ['Kalori', 'Protein', 'Karbohidrat', 'Lemak'];
  final List<String> months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  final List<String> years = ['2023', '2024', '2025', '2026'];
  final List<String> weekDays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    
    await initializeDateFormatting('id_ID', null);

    
    selectedMonth.value = DateFormat('MMMM', 'id_ID').format(DateTime.now());

    
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    isLoading.value = true;
    try {
      await fetchUserData();
      await fetchAllLogs();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserData() async {
    try {
      final data = await UserServices.to.fetchUserProfile();
      final userModel = UserModel.fromJson(data);
      user.value = userModel;
      
      _calculateBMI(userModel.height?.toDouble(), userModel.weight?.toDouble());
    } catch (e) {
      print('[Stats] Error fetching user: $e');
    }
  }

  Future<void> fetchAllLogs() async {
    try {
      
      final logs = await FoodLogService.to.getAllFoodLogs(limit: 100);
      allLogs.assignAll(logs);
      print('[Stats] Loaded ${logs.length} logs');
    } catch (e) {
      print('[Stats] Error fetching logs: $e');
    }
  }

  void _calculateBMI(double? height, double? weight) {
    if (height != null && weight != null && height > 0) {
      double heightM = height / 100;
      double bmi = weight / (heightM * heightM);
      bmiValue.value = double.parse(bmi.toStringAsFixed(1));

      if (bmi < 18.5) bmiStatus.value = 'Kurus';
      else if (bmi < 25) bmiStatus.value = 'Normal';
      else if (bmi < 30) bmiStatus.value = 'Gemuk';
      else bmiStatus.value = 'Obesitas';
    }
  }

  
  
  

  
  Map<String, Map<String, dynamic>> get nutritionData {
    
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    final todayLogs = allLogs.where((log) {
      
      
      return log.date.startsWith(todayStr);
    }).toList();

    
    Map<String, Map<String, dynamic>> data = {
      'Kalori': {'total': 2000, 'consumed': 0, 'sections': []},
      'Protein': {'total': 150, 'consumed': 0, 'sections': []},
      'Karbohidrat': {'total': 300, 'consumed': 0, 'sections': []},
      'Lemak': {'total': 70, 'consumed': 0, 'sections': []},
    };

    
    List<Map<String, dynamic>> initSections() => [
      {'label': 'Sarapan', 'value': 0},
      {'label': 'Makan Siang', 'value': 0},
      {'label': 'Makan Malam', 'value': 0},
    ];

    
    data.forEach((key, value) {
      value['sections'] = initSections();
    });

    
    for (var log in todayLogs) {
      
      int sectionIndex = -1;
      if (log.mealType == 'Breakfast') sectionIndex = 0;
      else if (log.mealType == 'Lunch') sectionIndex = 1;
      else if (log.mealType == 'Dinner') sectionIndex = 2;

      if (sectionIndex == -1) continue;

      
      for (var item in log.items) {
        int cal = item.calories; 
        double prot = _getNutrient(item, ['Protein']);
        double carb = _getNutrient(item, ['Karbohidrat', 'Carbs']);
        double fat = _getNutrient(item, ['Lemak', 'Fat']);

        
        _updateDailyData(data['Kalori']!, sectionIndex, cal);
        _updateDailyData(data['Protein']!, sectionIndex, (prot * item.servings).round());
        _updateDailyData(data['Karbohidrat']!, sectionIndex, (carb * item.servings).round());
        _updateDailyData(data['Lemak']!, sectionIndex, (fat * item.servings).round());
      }
    }

    return data;
  }

  void _updateDailyData(Map<String, dynamic> nutrientData, int sectionIndex, int value) {
    nutrientData['consumed'] = (nutrientData['consumed'] as int) + value;
    List sections = nutrientData['sections'];
    sections[sectionIndex]['value'] = (sections[sectionIndex]['value'] as int) + value;
  }

  
  Map<String, Map<String, dynamic>> get weeklyNutritionData {
    
    final now = DateTime.now();
    
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    

    
    Map<String, Map<String, dynamic>> data = {
      'Kalori': {'total': 2000, 'days': []},
      'Protein': {'total': 150, 'days': []},
      'Karbohidrat': {'total': 300, 'days': []},
      'Lemak': {'total': 70, 'days': []},
    };

    
    for (int i = 0; i < 7; i++) {
      final currentDayDate = startOfWeek.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(currentDayDate);

      
      final dayLogs = allLogs.where((log) => log.date.startsWith(dateStr)).toList();

      
      _calculateDayForWeekly(data['Kalori']!, 'Kalori', dayLogs, i);
      _calculateDayForWeekly(data['Protein']!, 'Protein', dayLogs, i);
      _calculateDayForWeekly(data['Karbohidrat']!, 'Karbohidrat', dayLogs, i);
      _calculateDayForWeekly(data['Lemak']!, 'Lemak', dayLogs, i);
    }

    return data;
  }

  void _calculateDayForWeekly(
      Map<String, dynamic> nutrientData,
      String nutrientName,
      List<FoodLogModel> logs,
      int dayIndex
      ) {
    int totalValue = 0;
    List<Map<String, dynamic>> breakdown = [
      {'label': 'Sarapan', 'value': 0},
      {'label': 'Makan Siang', 'value': 0},
      {'label': 'Makan Malam', 'value': 0},
    ];

    for (var log in logs) {
      int sectionIdx = -1;
      if (log.mealType == 'Breakfast') sectionIdx = 0;
      if (log.mealType == 'Lunch') sectionIdx = 1;
      if (log.mealType == 'Dinner') sectionIdx = 2;

      if (sectionIdx == -1) continue;

      for (var item in log.items) {
        double val = 0;
        if (nutrientName == 'Kalori') {
          val = item.calories.toDouble();
        } else {
          
          List<String> keys = [];
          if (nutrientName == 'Protein') keys = ['Protein'];
          if (nutrientName == 'Karbohidrat') keys = ['Karbohidrat', 'Carbs'];
          if (nutrientName == 'Lemak') keys = ['Lemak', 'Fat'];

          val = _getNutrient(item, keys) * item.servings;
        }

        totalValue += val.round();
        breakdown[sectionIdx]['value'] = (breakdown[sectionIdx]['value'] as int) + val.round();
      }
    }

    
    int target = nutrientData['total'];
    double percentage = (totalValue / target).clamp(0.0, 1.0);

    (nutrientData['days'] as List).add({
      'day': weekDays[dayIndex],
      'value': totalValue,
      'percentage': percentage,
      'breakdown': breakdown,
    });
  }

  
  Map<String, Map<String, dynamic>> get monthlyNutritionData {
    int year = int.tryParse(selectedYear.value) ?? DateTime.now().year;
    int monthIndex = months.indexOf(selectedMonth.value) + 1;
    
    if (monthIndex == 0) monthIndex = DateTime.now().month;

    int daysInMonth = DateTime(year, monthIndex + 1, 0).day;

    Map<String, Map<String, dynamic>> data = {
      'Kalori': {'total': 2000, 'days': []},
      'Protein': {'total': 150, 'days': []},
      'Karbohidrat': {'total': 300, 'days': []},
      'Lemak': {'total': 70, 'days': []},
    };

    
    for (int d = 1; d <= daysInMonth; d++) {
      String dateStr = '$year-${monthIndex.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';

      final dayLogs = allLogs.where((log) => log.date.startsWith(dateStr)).toList();

      _calculateDayForMonthly(data['Kalori']!, 'Kalori', dayLogs, d);
      _calculateDayForMonthly(data['Protein']!, 'Protein', dayLogs, d);
      _calculateDayForMonthly(data['Karbohidrat']!, 'Karbohidrat', dayLogs, d);
      _calculateDayForMonthly(data['Lemak']!, 'Lemak', dayLogs, d);
    }

    return data;
  }

  void _calculateDayForMonthly(
      Map<String, dynamic> nutrientData,
      String nutrientName,
      List<FoodLogModel> logs,
      int dayNumber
      ) {
    int totalValue = 0;

    for (var log in logs) {
      for (var item in log.items) {
        double val = 0;
        if (nutrientName == 'Kalori') {
          val = item.calories.toDouble();
        } else {
          List<String> keys = [];
          if (nutrientName == 'Protein') keys = ['Protein'];
          if (nutrientName == 'Karbohidrat') keys = ['Karbohidrat', 'Carbs'];
          if (nutrientName == 'Lemak') keys = ['Lemak', 'Fat'];
          val = _getNutrient(item, keys) * item.servings;
        }
        totalValue += val.round();
      }
    }

    int target = nutrientData['total'];
    double percentage = (totalValue / target).clamp(0.0, 1.0);

    (nutrientData['days'] as List).add({
      'day': dayNumber,
      'value': totalValue,
      'percentage': percentage,
    });
  }

  

  
  Map<String, dynamic> get filteredMonthlyData {
    final fullData = monthlyNutritionData[selectedNutrient.value]!;
    final allDays = fullData['days'] as List;

    final startIndex = currentDateRangeIndex.value * 5;
    final endIndex = (startIndex + 5).clamp(0, allDays.length);

    
    if (startIndex >= allDays.length) {
      return {
        'total': fullData['total'],
        'days': [],
        'startDay': 0,
        'endDay': 0,
      };
    }

    final filteredDays = allDays.sublist(startIndex, endIndex);

    return {
      'total': fullData['total'],
      'days': filteredDays,
      'startDay': filteredDays.isNotEmpty ? filteredDays.first['day'] : 1,
      'endDay': filteredDays.isNotEmpty ? filteredDays.last['day'] : 1,
    };
  }

  int get totalDateRanges {
    final fullData = monthlyNutritionData[selectedNutrient.value]!;
    final allDays = fullData['days'] as List;
    return (allDays.length / 5).ceil();
  }

  double _getNutrient(FoodLogItemModel item, List<String> keys) {
    if (item.food == null || item.food!.nutritionFacts.isEmpty) return 0.0;

    try {
      final fact = item.food!.nutritionFacts.firstWhere(
            (f) => keys.any((k) => f.name.toLowerCase().contains(k.toLowerCase())),
        orElse: () => NutritionFactModel(name: '', value: '0'),
      );
      String clean = fact.value.replaceAll(RegExp(r'[^0-9.,]'), '').replaceAll(',', '.');
      return double.tryParse(clean) ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  
  void changeTab(int index) {
    selectedTab.value = index;
    selectedDayIndex.value = -1;
  }

  void changeNutrient(String? nutrient) {
    if (nutrient != null) {
      selectedNutrient.value = nutrient;
      selectedDayIndex.value = -1;
    }
  }

  void toggleDaySelection(int index) {
    selectedDayIndex.value = (selectedDayIndex.value == index) ? -1 : index;
  }

  void changeMonth(String? month) {
    if (month != null) {
      selectedMonth.value = month;
      currentDateRangeIndex.value = 0;
    }
  }

  void changeYear(String? year) {
    if (year != null) {
      selectedYear.value = year;
      currentDateRangeIndex.value = 0;
    }
  }

  void nextDateRange() {
    if (currentDateRangeIndex.value < totalDateRanges - 1) currentDateRangeIndex.value++;
  }

  void previousDateRange() {
    if (currentDateRangeIndex.value > 0) currentDateRangeIndex.value--;
  }

  String get currentUnit => (selectedNutrient.value == 'Kalori') ? 'kkal' : 'g';
}