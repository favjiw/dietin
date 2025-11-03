import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isObscure = true.obs;
  var isConfirmObscure = true.obs;

  void toggle() {
    isObscure.value = !isObscure.value;
  }
}
