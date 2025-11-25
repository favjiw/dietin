import 'dart:convert';

import 'package:dietin/app/data/TokenModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/UserModel.dart';
import '../network/endpoint.dart';

class UserServices extends GetConnect {
  static UserServices get to => Get.find<UserServices>();
  final _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = 'https://selma-unrecorded-dearly.ngrok-free.dev';
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };

      print('Sending request to: ${httpClient.baseUrl}${Endpoint.register}');
      print('Request body: $body');

      final response = await post(Endpoint.register, body);

      print('Response status: ${response.statusCode}');
      print('Response statusText: ${response.statusText}');
      print('Response body: ${response.body}');
      print('Response bodyString: ${response.bodyString}');

      if (response.isOk) {
        dynamic resBody = response.body;

        if (resBody is String) {
          resBody = jsonDecode(resBody);
        }

        if (resBody is! Map<String, dynamic>) {
          throw Exception('Invalid response format');
        }

        final responseWrapper = resBody['response'];
        if (responseWrapper == null || responseWrapper is! Map<String, dynamic>) {
          throw Exception('Key "response" not found or invalid in response body');
        }

        final payload = responseWrapper['payload'];
        if (payload == null || payload is! Map<String, dynamic>) {
          throw Exception('Key "payload" not found or invalid in response body');
        }

        return UserModel.fromJson(payload);
      } else {
        String errorMessage = 'Failed to register user';

        final body = response.body;

        if (body is Map<String, dynamic> && body['message'] != null) {
          errorMessage = body['message'].toString();
        } else if (response.bodyString != null && response.bodyString!.isNotEmpty) {
          errorMessage = response.bodyString!;
        } else if (response.statusCode == null) {
          errorMessage = 'Unable to connect to server. Please check your internet or base URL.';
        } else {
          errorMessage = 'Failed to register user (Status: ${response.statusCode})';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error in register service: $e');
      rethrow;
    }
  }

//   make login
  Future<TokenModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
      };

      final response = await post(Endpoint.login, body);

      if (response.isOk) {
        dynamic resBody = response.body;

        if (resBody is String) {
          resBody = jsonDecode(resBody);
        }

        if (resBody is! Map<String, dynamic>) {
          throw Exception('Invalid response format');
        }

        final responseWrapper = resBody['response'];
        if (responseWrapper == null || responseWrapper is! Map<String, dynamic>) {
          throw Exception('Key "response" not found or invalid');
        }

        final payload = responseWrapper['payload'];
        if (payload == null || payload is! Map<String, dynamic>) {
          throw Exception('Key "payload" not found or invalid');
        }

        final tokenModel = TokenModel.fromJson(payload);

        // simpan token ke storage untuk dipakai onboard()
        await _storage.write('accessToken', tokenModel.accessToken);
        await _storage.write('refreshToken', tokenModel.refreshToken);

        return tokenModel;
      } else {
        String errorMessage = 'Failed to login user';

        final resBody = response.body;

        if (resBody is Map<String, dynamic> && resBody['message'] != null) {
          errorMessage = resBody['message'].toString();
        } else if (response.bodyString != null && response.bodyString!.isNotEmpty) {
          errorMessage = response.bodyString!;
        } else if (response.statusCode == null) {
          errorMessage = 'Unable to connect to server. Please check your internet or base URL.';
        } else {
          errorMessage = 'Failed to login user (Status: ${response.statusCode})';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error in login service: $e');
      rethrow;
    }
  }

  Future<void> onboard({
    required String birthDate,
    required double height,
    required double weight,
    required String gender,
    required String mainGoal,
    required double weightGoal,
    required String activityLevel,
    required List<String> allergies,
  }) async {
    try {
      final token = _storage.read<String>('accessToken');
      if (token == null || token.isEmpty) {
        throw Exception('Access token not found. Please login again.');
      }

      final body = {
        'birthDate': birthDate,
        'height': height,
        'weight': weight,
        'gender': gender,
        'mainGoal': mainGoal,
        'weightGoal': weightGoal,
        'activityLevel': activityLevel,
        'allergies': allergies,
      };

      final response = await post(
        Endpoint.onboard,
        body,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!response.isOk) {
        String errorMessage = 'Failed to submit onboarding data';
        final resBody = response.body;

        if (resBody is Map<String, dynamic> && resBody['message'] != null) {
          errorMessage = resBody['message'].toString();
        } else if (response.bodyString != null &&
            response.bodyString!.isNotEmpty) {
          errorMessage = response.bodyString!;
        } else if (response.statusCode == null) {
          errorMessage =
          'Unable to connect to server. Please check your internet or base URL.';
        } else {
          errorMessage =
          'Failed to submit onboarding data (Status: ${response.statusCode})';
        }

        throw Exception(errorMessage);
      }

      // optional: kalau ingin lihat payload
      // print('Onboard payload: ${response.body}');
    } catch (e) {
      print('Error in onboard service: $e');
      rethrow;
    }
  }
}
