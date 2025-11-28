import 'package:get/get.dart';

class BotnavbarController extends GetxController {
  var currentIndex = 0.obs;
  void changePages(int index) {
    currentIndex.value = index;
  }
}
