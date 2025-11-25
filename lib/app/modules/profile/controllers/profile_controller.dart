import 'package:dietin/app/data/UserModel.dart';
import 'package:dietin/app/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var name = 'Gilang Nanda Saputra'.obs;
  var height = 160.obs; // cm
  var weight = 61.obs;  // kg
  var age = 20.obs;     // tahun
  var timeZone = '07.00 WIB'.obs;

  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var errorMessage = ''.obs;

  final GetStorage _storage = GetStorage();

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

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

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    final hasHadBirthdayThisYear =
        (now.month > birthDate.month) ||
            (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hasHadBirthdayThisYear) {
      years -= 1;
    }
    return years;
  }

  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await UserServices.to.fetchUserProfile();
      final fetchedUser = UserModel.fromJson(data);
      user.value = fetchedUser;

      if (fetchedUser.name.isNotEmpty) {
        name.value = fetchedUser.name;
      }
      if (fetchedUser.height != null) {
        height.value = fetchedUser.height!;
      }
      if (fetchedUser.weight != null) {
        weight.value = fetchedUser.weight!;
      }
      if (fetchedUser.birthDate != null) {
        age.value = _calculateAge(fetchedUser.birthDate!);
      }

      print('[ProfileController] user loaded: ${user.value?.name}');
    } catch (e) {
      errorMessage.value = e.toString();
      print('[ProfileController] error: $e');

      Get.snackbar(
        'Error',
        'Gagal memuat profil pengguna: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.write(_isLoggedInKey, false);
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);

    Get.offAllNamed('/login');
  }
}
