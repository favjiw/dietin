import 'package:dietin/app/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var isObscure = true.obs;
  var isConfirmObscure = true.obs;

  var isLoading = false.obs;

  void toggle() {
    isObscure.value = !isObscure.value;
  }

  void toggleConfirm() {
    isConfirmObscure.value = !isConfirmObscure.value;
  }

  Future<void> register() async {
    
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Harap isi semua data.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Password dan Konfirmasi Password tidak sesuai.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = await UserServices.to.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      print('Registered user: ${user.name}, ${user.email}');

      Get.snackbar(
        'Sukses',
        'Berhasil melakukan registrasi. Silakan login.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      
      Get.offAllNamed('/login');

    } catch (e) {
      String errorMessage = e.toString();

      
      if (errorMessage.contains('Email already exists')) {
        errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
      } else if (errorMessage.contains('Invalid email')) {
        errorMessage = 'Format email tidak valid.';
      }

      Get.snackbar(
        'Gagal daftar akun',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      print('Registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
