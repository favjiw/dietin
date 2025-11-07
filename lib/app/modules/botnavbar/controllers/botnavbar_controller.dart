import 'package:get/get.dart';

class BotnavbarController extends GetxController {
  //TODO: Implement BotnavbarController

  var currentIndex = 0.obs;

  void changePages(int index) {
    currentIndex.value = index;
  }
}
