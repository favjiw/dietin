import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllergyCategory {
  final String id;
  final String label;
  final String asset;
  const AllergyCategory(this.id, this.label, this.asset);
}

class InitialhealthController extends GetxController {
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController targetWeightController = TextEditingController();

  final pageIndex = 0.obs;
  late PageController pageController;

  final selectedGender = Rx<String?>(null);
  final isGenderSelected = false.obs;

  final selectedActivityLevel = Rx<String?>(null);
  final isActivityLevelSelected = false.obs;

  final isBirthDateValid = false.obs;
  final isHeightValid = false.obs;
  final isWeightValid = false.obs;
  final isTargetWeightValid = false.obs;

  final selectedGoal = ''.obs;
  final goals = const [
    'Turun berat',
    'Naik berat',
    'Pertahankan berat',
    'Bangun otot',
  ];

  final allergyCategories = const <AllergyCategory>[
    AllergyCategory('susu_telur', 'Susu, Telur, dan Produk Susu Lainnya', 'assets/images/ic_dairy.png'),
    AllergyCategory('kacang', 'Kacang', 'assets/images/ic_peanut.png'),
    AllergyCategory('roti', 'Roti / Olahan Roti', 'assets/images/ic_wheat.png'),
    AllergyCategory('kafein', 'Teh dan Kopi', 'assets/images/ic_caffeine.png'),
    AllergyCategory('daging', 'Daging', 'assets/images/ic_meat.png'),
    AllergyCategory('kedelai', 'Kedelai', 'assets/images/ic_soy.png'),
    AllergyCategory('ikan', 'Ikan', 'assets/images/ic_fish.png'),
    AllergyCategory('udang', 'Udang / Kerang', 'assets/images/ic_shellfish.png'),
    AllergyCategory('wijen', 'Wijen', 'assets/images/ic_sesame.png'),
  ];

  // final selectedAllergies = <String>{}.obs;
  RxList<String> allergies = <String>[].obs;
  List<String> get selectedAllergies => allergies;

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

  bool get _isBirthDateEmpty => birthDateController.text.trim().isEmpty;
  bool get _isHeightEmpty => heightController.text.trim().isEmpty;
  bool get _isWeightEmpty => weightController.text.trim().isEmpty;
  bool get _isTargetWeightEmpty => targetWeightController.text.trim().isEmpty;
  bool get isGoalEmpty => selectedGoal.value.isEmpty;

  void _logState(String where) {
    Get.log('[$where] pageIndex=${pageIndex.value} currentPage=$_currentPage');
    Get.log('[$where] gender=${selectedGender.value}');
    Get.log('[$where] birth="${birthDateController.text}" '
        'isBirthDateValid=${isBirthDateValid.value} isEmpty=$_isBirthDateEmpty');
    Get.log('[$where] height="${heightController.text}" '
        'isHeightValid=${isHeightValid.value} isEmpty=$_isHeightEmpty');
    Get.log('[$where] weight="${weightController.text}" '
        'isWeightValid=${isWeightValid.value} isEmpty=$_isWeightEmpty');
    Get.log('[$where] target weight="${targetWeightController.text}" '
        'isTargetWeightValid=${isTargetWeightValid.value} isEmpty=$_isTargetWeightEmpty');
  }

  void toggleAllergy(String id) {
    if (selectedAllergies.contains(id)) {
      selectedAllergies.remove(id);
    } else {
      selectedAllergies.add(id);
    }
  }

  void setGoal(String v) {
    selectedGoal.value = v;
    goalController.text = v;
  }

  Future<void> completeOnboarding() async {
    if (validateAllFields()) {
      Get.log('Gender selected: ${selectedGender.value}');
      Get.log('Birth date: ${birthDateController.text}');
      Get.log('Height: ${heightController.text}');
      Get.log('Weight: ${weightController.text}');
      Get.log('Target Weight: ${targetWeightController.text}');
      Get.offAllNamed('/home');
    }
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
    isGenderSelected.value = true;
  }

  void selectActivity(String activity) {
    selectedActivityLevel.value = activity;
    isActivityLevelSelected.value = true;
  }

  bool validateBirthDate() {
    final text = birthDateController.text.trim();
    if (text.isEmpty) {
      isBirthDateValid.value = false;
      return false;
    }

    try {
      final parts = text.split('/');
      if (parts.length == 3) {
        final d = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final y = int.parse(parts[2]);
        final parsed = DateTime(y, m, d);
        final now = DateTime.now();

        if (parsed.isBefore(DateTime(now.year - 150)) || parsed.isAfter(now)) {
          isBirthDateValid.value = false;
          return false;
        }

        isBirthDateValid.value = true;
        return true;
      }
    } catch (_) {}

    isBirthDateValid.value = false;
    return false;
  }

  bool validateHeight() {
    final text = heightController.text.trim();
    if (text.isEmpty) {
      isHeightValid.value = false;
      return false;
    }

    try {
      final height = double.parse(text);
      if (height >= 50 && height <= 250) {
        isHeightValid.value = true;
        return true;
      }
    } catch (_) {}

    isHeightValid.value = false;
    return false;
  }

  bool validateWeight() {
    final text = weightController.text.trim();
    if (text.isEmpty) {
      isWeightValid.value = false;
      return false;
    }

    try {
      final weight = double.parse(text);
      if (weight >= 2 && weight <= 300) {
        isWeightValid.value = true;
        return true;
      }
    } catch (_) {}

    isWeightValid.value = false;
    return false;
  }

  bool validateTargetWeight() {
    final text = targetWeightController.text.trim();
    if (text.isEmpty) {
      isTargetWeightValid.value = false;
      return false;
    }
    try {
      final w = double.parse(text);
      if (w >= 2 && w <= 300) {
        isTargetWeightValid.value = true;
        return true;
      }
    } catch (_) {}
    isTargetWeightValid.value = false;
    return false;
  }

  bool validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        if (selectedGender.value == null) {
          Get.snackbar('Peringatan','Harap pilih jenis kelamin',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (_isBirthDateEmpty) {
          Get.snackbar('Peringatan','Tanggal lahir wajib diisi',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (!validateBirthDate()) {
          Get.snackbar('Peringatan','Harap pilih tanggal lahir yang valid',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (_isHeightEmpty) {
          Get.snackbar('Peringatan','Tinggi badan wajib diisi',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (!validateHeight()) {
          Get.snackbar('Peringatan','Harap masukkan tinggi badan yang valid (50–250 cm)',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (_isWeightEmpty) {
          Get.snackbar('Peringatan','Berat badan wajib diisi',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (!validateWeight()) {
          Get.snackbar('Peringatan','Harap masukkan berat badan yang valid (2–300 kg)',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        return true;

      case 1:
      // activity level

        // goal
        if (isGoalEmpty) {
          Get.snackbar('Peringatan','Harap pilih tujuan utama',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        // target weight
        if (_isTargetWeightEmpty) {
          Get.snackbar('Peringatan','Berat target wajib diisi',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (!validateTargetWeight()) {
          Get.snackbar('Peringatan','Harap masukkan berat target yang valid (2–300 kg)',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        if (selectedActivityLevel.value == null) {
          Get.snackbar('Peringatan','Harap pilih tingkat aktivitas',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return false;
        }
        return true;

      default:
        return false;
    }
  }


  bool validateAllFields() {
    if (selectedGender.value == null) return false;
    if (_isBirthDateEmpty || !validateBirthDate()) return false;
    if (_isHeightEmpty || !validateHeight()) return false;
    if (_isWeightEmpty || !validateWeight()) return false;
    if (selectedActivityLevel.value == null) return false;
    if (isGoalEmpty) return false;
    if (_isTargetWeightEmpty || !validateTargetWeight()) return false;
    return true;
  }


  int get _currentPage {
    if (!pageController.hasClients) return pageIndex.value;
    final p = pageController.page;
    return p == null ? pageIndex.value : p.round();
  }


  void nextPage() {
    _logState('nextPage:before');                                               // <— LOG
    final ok = validateCurrentPage();
    Get.log('[nextPage] validate=$ok currentPage=$_currentPage pageIndex=${pageIndex.value}');
    if (!ok) return;

    if (pageIndex.value < 2) {
      Get.log('[nextPage] moving to next page');                                // <— LOG
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Get.log('[nextPage] completing onboarding');                               // <— LOG
      completeOnboarding();
    }
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  Future<void> pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime initialDate = DateTime(now.year - 18, now.month, now.day);

    final t = birthDateController.text.trim();
    if (t.isNotEmpty) {
      try {
        final parts = t.split('/');
        if (parts.length == 3) {
          final d = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final y = int.parse(parts[2]);
          final parsed = DateTime(y, m, d);
          if (!parsed.isAfter(now) && parsed.year >= 1900) {
            initialDate = parsed;
          }
        }
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Pilih Tanggal Lahir',
      fieldHintText: 'DD/MM/YYYY',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      validateBirthDate();
    }
  }

  void onHeightChanged(String value) {
    validateHeight();
  }

  void onWeightChanged(String value) {
    validateWeight();
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();

    pageController.addListener(() {
      final p = pageController.page?.round();
      if (p != null && p != pageIndex.value) {
        pageIndex.value = p;
      }
    });

    birthDateController.addListener(validateBirthDate); // optional tapi bagus
    heightController.addListener(() => onHeightChanged(heightController.text));
    weightController.addListener(() => onWeightChanged(weightController.text));
  }


  @override
  void onClose() {
    birthDateController.dispose();
    heightController.dispose();
    weightController.dispose();
    pageController.dispose();
    super.onClose();
  }
}