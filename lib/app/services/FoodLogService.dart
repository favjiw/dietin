import 'package:dietin/app/data/FoodLogModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodLogService extends GetConnect {
  static FoodLogService get to => Get.find<FoodLogService>();
  final _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = 'https://selma-unrecorded-dearly.ngrok-free.dev';
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      final token = _storage.read('accessToken');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    super.onInit();
  }

  Future<void> logFood({
    required String date,
    required String mealType,
    required List<Map<String, dynamic>> foods,
  }) async {
    try {
      final body = {
        'date': date,
        'mealType': mealType,
        'foods': foods,
      };
      final response = await post('/food-logs', body);
      if (response.status.hasError) {
        throw Exception('Gagal mencatat makanan: ${response.statusText}');
      }
    } catch (e) {
      print('[FoodLogService] Error logFood: $e');
      rethrow;
    }
  }

  Future<List<FoodLogModel>> getFoodLogsByDate(String date) async {
    try {
      final url = '/food-logs/date?date=$date';
      final response = await get(url);

      if (response.status.hasError) {
        if (response.statusCode == 404) return [];
        throw Exception('Gagal memuat log: ${response.statusText}');
      }

      final body = response.body;
      if (body != null && body['response'] != null && body['response']['payload'] != null) {
        final List<dynamic> payload = body['response']['payload'];
        return payload.map((e) => FoodLogModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('[FoodLogService] Error getFoodLogsByDate: $e');
      return [];
    }
  }

  // --- NEW: Get All Food Logs (dengan limit) ---
  Future<List<FoodLogModel>> getAllFoodLogs({int limit = 100}) async {
    try {
      // Menggunakan limit 100 agar cukup untuk statistik bulanan
      // Backend query param: ?limit=100
      final response = await get('/food-logs', query: {'limit': limit.toString()});

      if (response.status.hasError) {
        throw Exception('Gagal memuat semua log: ${response.statusText}');
      }

      final body = response.body;
      // Sesuaikan parsing dengan struktur response backend (response -> payload)
      if (body != null && body['response'] != null && body['response']['payload'] != null) {
        final List<dynamic> payload = body['response']['payload'];
        return payload.map((e) => FoodLogModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('[FoodLogService] Error getAllFoodLogs: $e');
      return [];
    }
  }
}