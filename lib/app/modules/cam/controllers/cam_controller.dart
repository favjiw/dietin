import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dietin/app/routes/app_pages.dart';
import 'package:dietin/app/services/FoodService.dart';
import 'package:dietin/app/shared/constants/colors.dart';
import 'package:dietin/app/shared/constants/text_style.dart';
import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CamController extends GetxController {
  // State Mode: True = Photo (AI), False = Scan (Barcode)
  var isPhotoMode = true.obs;

  // State Loading untuk proses upload API
  var isLoading = false.obs;

  // State untuk Dropdown Pilihan Waktu Makan
  var selectedMealType = 'Breakfast'.obs;

  // --- KAMERA NATIVE (Untuk Foto AI) ---
  CameraController? cameraController;
  List<CameraDescription>? _cameras;
  var isCameraInitialized = false.obs;

  // --- SCANNER (Untuk Barcode) ---
  late MobileScannerController scannerController;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi controller scanner
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      autoStart: false,
    );

    // Default mulai di mode Foto
    _initializeCamera();
  }

  @override
  void onClose() {
    // Pastikan resource dilepas dengan aman saat controller mati
    _disposeCamera();
    scannerController.dispose();
    super.onClose();
  }

  // --- HELPER: Matikan Kamera dengan Aman ---
  Future<void> _disposeCamera() async {
    if (cameraController != null) {
      try {
        if (cameraController!.value.isStreamingImages) {
          await cameraController!.stopImageStream();
        }
      } catch (_) {}

      try {
        await cameraController!.dispose();
      } catch (e) {
        print("Error disposing camera: $e");
      }

      cameraController = null;
      isCameraInitialized.value = false;
    }
  }

  // --- LOGIKA GANTI MODE (Lifecycle Management) ---
  Future<void> toggleMode() async {
    if (isPhotoMode.value) {
      // BERPINDAH KE SCAN MODE (Barcode)
      await _disposeCamera();
      isPhotoMode.value = false;

      await Future.delayed(const Duration(milliseconds: 200));
      try {
        await scannerController.start();
      } catch (e) {
        print("Error starting scanner: $e");
      }

    } else {
      // BERPINDAH KE PHOTO MODE (AI)
      await scannerController.stop();
      isPhotoMode.value = true;
      await _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      if (_cameras == null) {
        _cameras = await availableCameras();
      }

      if (_cameras != null && _cameras!.isNotEmpty) {
        await _disposeCamera();

        cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController!.initialize();
        if (isClosed) return;

        isCameraInitialized.value = true;
      } else {
        Get.snackbar("Error", "Kamera tidak ditemukan");
      }
    } catch (e) {
      print("Error init camera: $e");
    }
  }


  // --- FITUR 1: AMBIL FOTO & SCAN AI ---
  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized || isLoading.value) {
      return;
    }

    if (cameraController!.value.isTakingPicture) {
      return;
    }

    try {
      isLoading.value = true;

      final XFile image = await cameraController!.takePicture();
      File imageFile = File(image.path);

      final scanResult = await FoodService.to.scanFood(imageFile);

      isLoading.value = false;

      if (scanResult != null) {
        _showScanResultSheet(scanResult, imageFile);
      }

    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Gagal",
        "Gagal memproses foto: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- FITUR 2: SCAN BARCODE ---
  void onBarcodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        scannerController.stop();

        Get.snackbar(
          "Barcode Ditemukan",
          "Kode: ${barcode.rawValue}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }


  // --- BOTTOM SHEET HASIL AI (UPDATED STYLE) ---
  void _showScanResultSheet(Map<String, dynamic> data, File imageFile) {
    // Set default meal type based on time
    final hour = DateTime.now().hour;
    if (hour >= 11 && hour < 16) {
      selectedMealType.value = 'Lunch';
    } else if (hour >= 16) {
      selectedMealType.value = 'Dinner';
    } else {
      selectedMealType.value = 'Breakfast';
    }

    Get.bottomSheet(
      Container(
        height: 0.85.sh, // Tinggi sheet hampir full screen agar muat banyak detail
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondaryWhite, // Background agak abu-abu seperti detail page
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Container(
                width: 60.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Preview (Rounded seperti Detail View)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Image.file(
                          imageFile,
                          width: double.infinity,
                          height: 250.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Title
                    Text(
                      data['name'] ?? 'Makanan Terdeteksi',
                      style: AppTextStyles.foodTitle,
                    ),
                    SizedBox(height: 12.h),

                    // Tags Row (Kalori, Serving, Prep Time)
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildTag(
                            '${data['nutritionFacts'] != null ? _findNutrientValue(data['nutritionFacts'], 'Kalori') : 0}',
                            AppColors.primary,
                            Icons.local_fire_department
                        ),
                        if (data['servings'] != null)
                          _buildTag(
                              '${data['servings']} ${data['servingType'] ?? 'porsi'}',
                              AppColors.yellow,
                              Icons.restaurant_menu
                          ),
                        if (data['prepTime'] != null)
                          _buildTag(
                              '${data['prepTime']} min',
                              Colors.blueAccent,
                              Icons.timer_outlined
                          ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // --- DROPDOWN MEAL TYPE ---
                    Text("Dimakan saat?", style: AppTextStyles.labelBold),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedMealType.value,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                          items: [
                            _buildDropdownItem('Breakfast', 'Sarapan'),
                            _buildDropdownItem('Lunch', 'Makan Siang'),
                            _buildDropdownItem('Dinner', 'Makan Malam'),
                          ],
                          onChanged: (value) {
                            if (value != null) selectedMealType.value = value;
                          },
                        ),
                      )),
                    ),
                    SizedBox(height: 24.h),

                    // --- INFORMASI NUTRISI ---
                    if (data['nutritionFacts'] != null && (data['nutritionFacts'] as List).isNotEmpty) ...[
                      Text('Informasi Nutrisi', style: AppTextStyles.foodLabel),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: (data['nutritionFacts'] as List).map<Widget>((fact) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(fact['name'] ?? '', style: AppTextStyles.bodyLight),
                                  Text(fact['value'] ?? '', style: AppTextStyles.bodySmallSemiBold),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // --- BAHAN-BAHAN ---
                    if (data['ingredients'] != null && (data['ingredients'] as List).isNotEmpty) ...[
                      Text('Bahan', style: AppTextStyles.foodLabel),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: (data['ingredients'] as List).map<Widget>((ing) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ing['name'] ?? '', style: AppTextStyles.bodySmall),
                                  Text(ing['quantity'] ?? '', style: AppTextStyles.bodyLight),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // --- DESKRIPSI (Optional) ---
                    if (data['description'] != null) ...[
                      Text('Deskripsi', style: AppTextStyles.foodLabel),
                      SizedBox(height: 8.h),
                      Text(
                        data['description'],
                        style: AppTextStyles.bodyLight,
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // Space agar konten tidak tertutup tombol
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),

            // --- ACTION BUTTONS (FIXED BOTTOM) ---
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    )
                  ]
              ),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Tambah Makanan',
                    backgroundColor: AppColors.mainBlack,
                    borderRadius: 64,
                    textStyle: AppTextStyles.label.copyWith(
                      color: AppColors.light,
                      fontSize: 18.sp,
                    ),
                    onPressed: () => _saveScanLog(data),
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    text: 'Batal',
                    borderRadius: 64,
                    backgroundColor: Colors.transparent,
                    onPressed: () => Get.back(),
                    textStyle: AppTextStyles.label.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    ).then((_) {
      // Reset loading state jika ditutup manual
      isLoading.value = false;
    });
  }

  // --- WIDGET HELPER: Tag (Pill Shape) ---
  Widget _buildTag(String text, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.recom.copyWith(fontSize: 11.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String label) {
    return DropdownMenuItem(
      value: value,
      child: Text(label, style: AppTextStyles.bodySmall),
    );
  }

  String _findNutrientValue(List<dynamic> facts, String keyName) {
    try {
      final fact = facts.firstWhere(
            (f) => f['name'].toString().toLowerCase().contains(keyName.toLowerCase()),
        orElse: () => null,
      );
      return fact != null ? fact['value'].toString() : '-';
    } catch (e) {
      return '-';
    }
  }

  void _saveScanLog(Map<String, dynamic> data) async {
    try {
      // 1. Matikan kamera dulu
      await _disposeCamera();

      Get.back(); // Tutup bottom sheet
      isLoading.value = true;

      String mealType = selectedMealType.value;

      final logData = {
        ...data,
        'mealType': mealType,
        'date': DateTime.now().toIso8601String().split('T')[0],
        'servingsConsumed': 1
      };

      await FoodService.to.scanAndLogFood(logData);

      isLoading.value = false;

      Get.snackbar(
        'Berhasil',
        'Makanan berhasil dicatat ke $mealType!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigasi aman kembali ke halaman utama
      Get.until((route) => route.settings.name == Routes.BOTNAVBAR);

    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Gagal', 'Gagal menyimpan log: $e');
    }
  }
}