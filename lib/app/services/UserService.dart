import 'dart:convert';

import 'package:dietin/app/data/TokenModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/UserModel.dart';
import '../network/endpoint.dart';

class UserServices extends GetConnect {
  static UserServices get to => Get.find<UserServices>();
  final _storage = GetStorage();

  UserServices() {
    httpClient.timeout = const Duration(seconds: 30);
  }

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
          errorMessage =
          'Unable to connect to server. Please check your internet or base URL.';
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
          errorMessage =
          'Unable to connect to server. Please check your internet or base URL.';
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
    } catch (e) {
      print('Error in onboard service: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile({bool retryOnAuthError = true}) async {
    final String? accessToken = _storage.read<String>('accessToken');

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token not found. Please login again.');
    }

    print('[UserServices] using accessToken: $accessToken');
    print('[UserServices] baseUrl: ${httpClient.baseUrl}');
    print('[UserServices] calling: ${httpClient.baseUrl}${Endpoint.user}');

    Response response;
    try {
      response = await get(
        Endpoint.user, // pastikan Endpoint.user = '/user'
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      print('[UserServices] /user connection error: $e');
      throw Exception('Connection error when calling /user: $e');
    }

    print('[UserServices] /user statusCode=${response.statusCode}');
    print('[UserServices] /user statusText=${response.statusText}');
    print('[UserServices] /user body=${response.bodyString}');
    print('[UserServices] /user requestUrl=${response.request?.url}');

    if (response.statusCode == null) {
      throw Exception(
        'Failed to fetch user profile. Code: null, body: null. Possible invalid URL or network error.',
      );
    }

    if (response.statusCode == 401 &&
        retryOnAuthError &&
        response.bodyString != null &&
        response.bodyString!.contains('access token has expired')) {
      print('[UserServices] access token expired → refreshing...');
      await _refreshAccessToken();
      return fetchUserProfile(retryOnAuthError: false);
    }

    if (!response.isOk) {
      throw Exception(
        'Failed to fetch user profile. Code: ${response.statusCode}, body: ${response.bodyString}',
      );
    }

    dynamic body = response.body;
    if (body is String) {
      body = jsonDecode(body);
    }

    if (body is! Map<String, dynamic>) {
      throw Exception('Invalid response format (root is not object)');
    }

    final responseWrapper = body['response'];
    if (responseWrapper == null || responseWrapper is! Map<String, dynamic>) {
      throw Exception('Key "response" not found or invalid');
    }

    final payload = responseWrapper['payload'];
    if (payload == null || payload is! Map<String, dynamic>) {
      throw Exception('Key "payload" not found or invalid');
    }

    return Map<String, dynamic>.from(payload);
  }

  Future<void> _refreshAccessToken() async {
    final String? refreshToken = _storage.read<String>('refreshToken');

    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Refresh token not found. Please login again.');
    }

    print('[UserServices] trying refresh token...');
    print('[UserServices] refreshToken: $refreshToken');

    Response response;
    try {
      response = await post(
        Endpoint.refreshToken, // buat di endpoint.dart: static const refreshToken = '/token';
        {
          'token': refreshToken,
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      print('[UserServices] /token connection error: $e');
      throw Exception('Connection error when calling /token: $e');
    }

    print('[UserServices] /token status=${response.statusCode}');
    print('[UserServices] /token body=${response.bodyString}');

    if (!response.isOk) {
      throw Exception(
        'Failed to refresh token. Code: ${response.statusCode}, body: ${response.bodyString}',
      );
    }

    dynamic body = response.body;
    if (body is String) {
      body = jsonDecode(body);
    }

    if (body is! Map<String, dynamic>) {
      throw Exception('Invalid refresh response: root is not object');
    }

    final responseWrapper = body['response'];
    if (responseWrapper == null || responseWrapper is! Map<String, dynamic>) {
      throw Exception('Invalid refresh response: missing "response"');
    }

    final payload = responseWrapper['payload'];
    if (payload == null || payload is! Map<String, dynamic>) {
      throw Exception('Invalid refresh response: missing "payload"');
    }

    final tokens = TokenModel.fromJson(payload);

    await _storage.write('accessToken', tokens.accessToken);
    await _storage.write('refreshToken', tokens.refreshToken);

    print('[UserServices] refresh success → tokens updated');
  }
}