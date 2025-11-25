import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var name = 'Gilang Nanda Saputra'.obs;
  var height = 160.obs; // in cm
  var weight = 61.obs; // in kg
  var age = 20.obs; // in years
  var timeZone = '07.00 WIB'.obs;

  final GetStorage _storage = GetStorage();

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

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

  Future<void> logout() async {
    await _storage.write(_isLoggedInKey, false);

    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);

    Get.offAllNamed('/login');
  }
}
