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

  void toggle() {
    isObscure.value = !isObscure.value;
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
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

      print("Access: ${tokens.accessToken}");
      print("Refresh: ${tokens.refreshToken}");

      final storage = GetStorage();
      await storage.write('is_logged_in', true);
      await storage.write('accessToken', tokens.accessToken);
      await storage.write('refreshToken', tokens.refreshToken);

      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      emailController.clear();
      passwordController.clear();

      final bool isInitialCompleted =
          storage.read('initial_health_completed') == true;

      if (isInitialCompleted) {
        Get.offAllNamed('/botnavbar');
      } else {
        Get.offAllNamed('/initialhealth');
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}