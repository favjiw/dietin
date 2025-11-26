import 'dart:async';
import 'package:dietin/app/data/FoodModel.dart';
import 'package:dietin/app/network/endpoint.dart';
import 'package:get/get.dart';

class FoodService extends GetConnect {
  static FoodService get to => Get.find<FoodService>();

  @override
  void onInit() {
    // Sesuaikan base URL dengan environment Anda
    httpClient.baseUrl = 'https://selma-unrecorded-dearly.ngrok-free.dev';
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  // Fetch sekali jalan (Future)
  Future<List<FoodModel>> getAllFoods() async {
    try {
      print('[FoodService] Fetching foods from: ${httpClient.baseUrl}${Endpoint.foods}');

      final response = await get(Endpoint.foods);

      if (response.status.hasError) {
        throw Exception('Gagal memuat makanan: ${response.statusText} (Code: ${response.statusCode})');
      }

      final body = response.body;

      if (body != null && body['response'] != null && body['response']['payload'] != null) {
        final List<dynamic> payload = body['response']['payload'];
        return payload.map((e) => FoodModel.fromJson(e)).toList();
      } else {
        if (body is List) {
          return body.map((e) => FoodModel.fromJson(e)).toList();
        }
        throw Exception('Gagal memuat makanan: Struktur respons tidak valid atau payload kosong');
      }
    } catch (e) {
      print('[FoodService] Error: $e');
      return [];
    }
  }

  // Stream Realtime (Polling)
  Stream<List<FoodModel>> getAllFoodsStream({Duration interval = const Duration(seconds: 10)}) async* {
    yield await getAllFoods();
    yield* Stream.periodic(interval, (_) {
      return getAllFoods();
    }).asyncMap((event) async => await event);
  }

  // Fetch Detail Food by ID
  Future<FoodModel?> getFoodById(int id) async {
    try {
      final url = '${Endpoint.foods}/$id';
      print('[FoodService] Fetching food detail from: ${httpClient.baseUrl}$url');

      final response = await get(url);

      if (response.status.hasError) {
        throw Exception('Gagal memuat detail makanan: ${response.statusText}');
      }

      final body = response.body;
      if (body != null && body['response'] != null && body['response']['payload'] != null) {
        return FoodModel.fromJson(body['response']['payload']);
      } else {
        throw Exception('Gagal memuat detail makanan: Struktur respons tidak valid');
      }
    } catch (e) {
      print('[FoodService] Error getFoodById: $e');
      rethrow;
    }
  }
}