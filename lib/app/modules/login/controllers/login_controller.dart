import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isObscure = true.obs;
  var isConfirmObscure = true.obs;

  void toggle() {
    isObscure.value = !isObscure.value;
  }

  final count = 0.obs;

  void increment() => count.value++;
}
