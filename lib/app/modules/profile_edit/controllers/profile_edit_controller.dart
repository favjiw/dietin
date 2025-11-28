import 'package:dietin/app/data/UserModel.dart';
import 'package:dietin/app/modules/profile/controllers/profile_controller.dart';
import 'package:dietin/app/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  final UserServices _userServices = Get.find<UserServices>();

  
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  
  var user = Rxn<UserModel>();
  var isLoading = false.obs;
  var isSaving = false.obs;
  var errorMessage = ''.obs;

  
  var fullName = ''.obs;
  var email = ''.obs;
  var birthDate = ''.obs;
  var height = ''.obs;
  var weight = ''.obs;
  RxList<String> allergies = <String>[].obs;
  List<String> get selectedAllergies => allergies;

  
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void _syncControllers(UserModel fetchedUser) {
    fullName.value = fetchedUser.name;
    email.value = fetchedUser.email;
    birthDate.value = fetchedUser.birthDate != null
        ? fetchedUser.birthDate!.toLocal().toString().split(' ')[0] 
        : '';
    height.value = fetchedUser.height?.toString() ?? '';
    weight.value = fetchedUser.weight?.toString() ?? '';
    allergies.assignAll(fetchedUser.allergies);

    fullNameController.text = fullName.value;
    emailController.text = email.value;
    birthDateController.text = birthDate.value;
    heightController.text = height.value;
    weightController.text = weight.value;
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _userServices.fetchUserProfile();
      final fetchedUser = UserModel.fromJson(data);
      user.value = fetchedUser;

      _syncControllers(fetchedUser);

      print('[ProfileEditController] User profile fetched successfully.');
    } catch (e) {
      errorMessage.value = e.toString();
      print('[ProfileEditController] Error fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> updateProfile() async {
    if (fullNameController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar('Error', 'Nama dan Email tidak boleh kosong.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';

      
      await Future.delayed(const Duration(seconds: 2));

      
      fullName.value = fullNameController.text.trim();
      email.value = emailController.text.trim();
      height.value = heightController.text.trim();
      weight.value = weightController.text.trim();
      birthDate.value = birthDateController.text.trim(); 
      

      Get.snackbar('Berhasil', 'Profil berhasil diperbarui.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);

      
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().fetchUser();
      }

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Gagal', 'Gagal menyimpan profil: $e', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }


  final List<String> allAllergyOptions = [
    'Susu, Telur, dan Produk Susu Lainnya',
    'Roti / Olahan Roti',
    'Daging',
    'Udang',
    'Kacang',
    'Teh dan Kopi',
    'Kedelai',
    'Wijen',
    'Ikan',
  ];

  final Map<String, String> allAllergyOptionsWithAssets = {
    'Susu, Telur, dan Produk Susu Lainnya': 'assets/images/susu.png',
    'Roti / Olahan Roti': 'assets/images/roti.png',
    'Daging': 'assets/images/daging.png',
    'Udang': 'assets/images/udang.png',
    'Kacang': 'assets/images/kacang.png',
    'Teh dan Kopi': 'assets/images/tehdankopi.png',
    'Kedelai': 'assets/images/kedelai.png',
    'Wijen': 'assets/images/wijen.png',
    'Ikan': 'assets/images/ikan.png',
  };

  void addAllergy(String allergy) {
    if (!allergies.contains(allergy)) {
      allergies.add(allergy);
    }
  }

  void removeAllergy(String allergy) {
    allergies.remove(allergy);
  }

  void toggleAllergy(String allergy) {
    if (allergies.contains(allergy)) {
      allergies.remove(allergy);
    } else {
      allergies.add(allergy);
    }
  }
}