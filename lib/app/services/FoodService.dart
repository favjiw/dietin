import 'dart:async';
import 'package:dietin/app/data/FoodLogModel.dart';
import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/network/endpoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodService extends GetConnect {
  static FoodService get to => Get.find<FoodService>();
  final _storage = GetStorage();

  @override
  void onInit() {
    // Ganti dengan URL backend Anda yang benar
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

  Future<List<FoodModel>> getAllFoods() async {
    try {
      final response = await get(Endpoint.foods);
      if (response.status.hasError) {
        throw Exception('Gagal memuat makanan: ${response.statusText}');
      }
      final body = response.body;
      if (body != null && body['response'] != null && body['response']['payload'] != null) {
        final List<dynamic> payload = body['response']['payload'];
        return payload.map((e) => FoodModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('[FoodService] Error: $e');
      return [];
    }
  }

  Stream<List<FoodModel>> getAllFoodsStream({Duration interval = const Duration(seconds: 10)}) async* {
    yield await getAllFoods();
    yield* Stream.periodic(interval, (_) => getAllFoods()).asyncMap((e) async => await e);
  }

  Future<FoodModel?> getFoodById(int id) async {
    try {
      final url = '${Endpoint.foods}/$id';
      final response = await get(url);
      if (response.status.hasError) throw Exception('Gagal memuat detail: ${response.statusText}');
      final body = response.body;
      if (body != null && body['response'] != null && body['response']['payload'] != null) {
        return FoodModel.fromJson(body['response']['payload']);
      }
      return null;
    } catch (e) {
      print('[FoodService] Error getFoodById: $e');
      rethrow;
    }
  }

  // GET /food-logs/date?date=YYYY-MM-DD
  Future<List<FoodLogModel>> getFoodLogsByDate(String date) async {
    try {
      final url = '/food-logs/date?date=$date';
      print('[FoodService] Fetching logs: ${httpClient.baseUrl}$url');

      final response = await get(url);

      if (response.status.hasError) {
        // Jika 404 (belum ada log hari ini), return list kosong jangan throw error
        if (response.statusCode == 404) return [];

        throw Exception('Gagal memuat log makanan: ${response.statusText} (${response.statusCode})');
      }

      final body = response.body;
      if (body != null && body['response'] != null && body['response']['payload'] != null) {
        final List<dynamic> payload = body['response']['payload'];
        return payload.map((e) => FoodLogModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('[FoodService] Error getFoodLogsByDate: $e');
      return [];
    }
  }
}