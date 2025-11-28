import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dietin/app/data/FoodLogModel.dart';
import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/network/endpoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FoodService extends GetConnect {
  static FoodService get to => Get.find<FoodService>();
  final _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
    httpClient.timeout = const Duration(seconds: 60);

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

  Future<List<FoodLogModel>> getFoodLogsByDate(String date) async {
    try {
      final url = '/food-logs/date?date=$date';
      print('[FoodService] Fetching logs: ${httpClient.baseUrl}$url');

      final response = await get(url);

      if (response.status.hasError) {
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

  Future<dynamic> scanFood(File imageFile) async {
    try {
      final form = FormData({
        'image': MultipartFile(
            imageFile,
            filename: 'food_scan.jpg',
            contentType: 'image/jpeg'
        ),
      });

      final response = await post(Endpoint.foodScan, form);


      var body = response.body;


      if (body is String) {
        try {

          if (body.trim().toLowerCase().startsWith('<!doctype html') ||
              body.trim().toLowerCase().startsWith('<html')) {
            print("Server returned HTML Error: $body");
            throw Exception("Server Error (HTML Response). Cek log server.");
          }
          body = jsonDecode(body);
        } catch (e) {
          print("Gagal decode JSON: $body");
        }
      }

      if (response.status.hasError) {
        String message = 'Gagal memindai makanan';
        if (body is Map && body['message'] != null) {
          message = body['message'];
        } else if (body is String) {
          if (body.length < 100) message = body;
          else message = 'Server Error: ${response.statusText}';
        }

        throw Exception(message);
      }

      if (body is Map &&
          body['response'] != null &&
          body['response']['payload'] != null) {
        return body['response']['payload'];
      }

      return null;

    } catch (e) {
      print('[FoodService] Error scanFood: $e');
      rethrow;
    }
  }

  Future<bool> scanAndLogFood(Map<String, dynamic> foodData) async {
    try {
      final response = await post(Endpoint.foodScanLog, foodData);

      if (response.status.hasError) {
        var body = response.body;
        if (body is String) {
          try { body = jsonDecode(body); } catch (_) {}
        }

        String msg = 'Gagal menyimpan makanan';
        if (body is Map && body['message'] != null) msg = body['message'];

        throw Exception(msg);
      }

      return true;
    } catch (e) {
      print('[FoodService] Error scanAndLogFood: $e');
      rethrow;
    }
  }

  Future<dynamic> searchFoodByUpc(String upc) async {
    try {
      final response = await get('${Endpoint.foodUpc}/$upc');

      var body = response.body;
      if (body is String) {
        try { body = jsonDecode(body); } catch (_) {}
      }

      if (response.status.hasError) {
        String message = 'Gagal mencari produk';
        if (body is Map && body['message'] != null) {
          message = body['message'];
        }
        throw Exception(message);
      }

      if (body is Map && body['response'] != null && body['response']['payload'] != null) {
        return body['response']['payload'];
      }
      return null;
    } catch (e) {
      print('[FoodService] Error searchFoodByUpc: $e');
      rethrow;
    }
  }

  Future<bool> logFoodByUpc(String upc, Map<String, dynamic> logData) async {
    try {
      final response = await post('${Endpoint.foodUpc}/$upc/log', logData);
      var body = response.body;
      if (body is String) {
        try { body = jsonDecode(body); } catch (_) {}
      }

      if (response.status.hasError) {
        String msg = 'Gagal menyimpan log UPC';
        if (body is Map && body['message'] != null) msg = body['message'];
        throw Exception(msg);
      }
      return true;
    } catch (e) {
      print('[FoodService] Error logFoodByUpc: $e');
      rethrow;
    }
  }
}