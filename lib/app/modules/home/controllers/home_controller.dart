import 'package:get/get.dart';
import 'package:dietin/app/services/UserService.dart';
import 'package:dietin/app/data/UserModel.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // asumsi: UserServices.to.fetchUserProfile() mengembalikan Map<String, dynamic>
      final data = await UserServices.to.fetchUserProfile();
      user.value = UserModel.fromJson(data);

      print('[HomeController] user loaded: ${user.value?.name}');
    } catch (e) {
      errorMessage.value = e.toString();
      print('[HomeController] error: $e');

      Get.snackbar(
        'Error',
        'Gagal memuat profil pengguna: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
