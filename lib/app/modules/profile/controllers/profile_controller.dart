import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = 'Gilang Nanda Saputra'.obs;
  var height = 160.obs; // in cm
  var weight = 61.obs; // in kg
  var age = 20.obs; // in years
  var timeZone = '07.00 WIB'.obs;

  void updateName(String newName) {
    name.value = newName;
  }

  void updateHeight(int newHeight) {
    height.value = newHeight;
  }

  void updateWeight(int newWeight) {
    weight.value = newWeight;
  }

  void updateAge(int newAge) {
    age.value = newAge;
  }

  void updateTimeZone(String newTimeZone) {
    timeZone.value = newTimeZone;
  }
}
