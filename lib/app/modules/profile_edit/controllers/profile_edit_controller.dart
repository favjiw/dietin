import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  var fullName = 'Gilang Nanda Saputra'.obs;
  var email = 'gilangrajagula@gmail.com'.obs;
  var birthDate = '69 Februari 1907'.obs;
  var height = '160'.obs;
  var weight = '61'.obs;

  RxList<String> allergies = <String>[].obs;
  List<String> get selectedAllergies => allergies;


  // init textfield with current values
  @override
  void onInit() {
    super.onInit();
    fullNameController.text = fullName.value;
    emailController.text = email.value;
    birthDateController.text = birthDate.value;
    heightController.text = height.value;
    weightController.text = weight.value;
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

  void updateFullName(String value) => fullName.value = value;
  void updateEmail(String value) => email.value = value;
  void updateBirthDate(String value) => birthDate.value = value;
  void updateHeight(String value) => height.value = value;
  void updateWeight(String value) => weight.value = value;
}