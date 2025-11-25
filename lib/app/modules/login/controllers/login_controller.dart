import 'package:dietin/app/data/TokenModel.dart';
import 'package:dietin/app/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isObscure = true.obs;
  var isLoading = false.obs;

  final GetStorage _storage = GetStorage();
  static const String _initialCompletedKey = 'initial_health_completed';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  void toggle() {
    isObscure.value = !isObscure.value;
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Harai isi semua data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final TokenModel tokens = await UserServices.to.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // simpan status login dan token
      await _storage.write(_isLoggedInKey, true);
      await _storage.write(_accessTokenKey, tokens.accessToken);
      await _storage.write(_refreshTokenKey, tokens.refreshToken);

      print("Access: ${tokens.accessToken}");
      print("Refresh: ${tokens.refreshToken}");

      Get.snackbar(
        'Sukses',
        'Berhasil login',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // bersihkan form
      emailController.clear();
      passwordController.clear();

      final bool isInitialCompleted =
          _storage.read(_initialCompletedKey) == true;

      // alur setelah login
      if (isInitialCompleted) {
        Get.offAllNamed('/botnavbar');
      } else {
        Get.offAllNamed('/initialhealth');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Login',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}