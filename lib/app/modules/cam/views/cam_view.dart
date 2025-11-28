import 'package:camera/camera.dart';
import 'package:dietin/app/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/cam_controller.dart';

class CamView extends GetView<CamController> {
  const CamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: TAMPILAN KAMERA / SCANNER
          Obx(() {
            if (controller.isPhotoMode.value) {
              // --- MODE FOTO (AI SCAN) ---
              if (controller.isCameraInitialized.value &&
                  controller.cameraController != null &&
                  controller.cameraController!.value.isInitialized) {
                return SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: CameraPreview(controller.cameraController!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            } else {
              // --- MODE SCAN (BARCODE) ---
              return MobileScanner(
                controller: controller.scannerController,
                onDetect: controller.onBarcodeDetect,
                fit: BoxFit.cover,
                // Gunakan overlay builder bawaan package atau custom container di atasnya
                overlayBuilder: (context, constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.5),
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 0.25.sh // Agar kotak ada di tengah agak ke atas
                    ),
                  );
                },
              );
            }
          }),

          // LAYER 2: HEADER & TOMBOL KEMBALI
          Positioned(
            top: 50.h,
            left: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Judul Mode di Atas (Opsional, agar user tau sedang mode apa)
          Positioned(
            top: 60.h,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  controller.isPhotoMode.value ? 'Pindai Makanan' : 'Pindai Barcode',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              )),
            ),
          ),

          // LAYER 3: CONTROLS AREA (BAWAH)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 30.h, top: 20.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. TOMBOL SHUTTER (HANYA DI MODE FOTO)
                  Obx(() {
                    if (controller.isPhotoMode.value) {
                      return GestureDetector(
                        onTap: () => controller.takePicture(),
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4.w),
                          ),
                          child: controller.isLoading.value
                              ? Padding(
                            padding: EdgeInsets.all(10.w),
                            child: const CircularProgressIndicator(color: Colors.white),
                          )
                              : Container(
                            margin: EdgeInsets.all(5.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Spacer agar layout selector tidak naik turun
                      return SizedBox(height: 80.w);
                    }
                  }),

                  SizedBox(height: 30.h),

                  // 2. SELECTOR MODE (PHOTO / SCAN)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildModeButton("Photo", true),
                        _buildModeButton("Scan", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LAYER 4: LOADING OVERLAY FULL SCREEN (Opsional, jika ingin memblokir interaksi saat upload)
          Obx(() => controller.isLoading.value
              ? Container(
            color: Colors.black54,
            width: 1.sw,
            height: 1.sh,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16.h),
                const Text(
                  "Menganalisis Makanan...",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
              : const SizedBox.shrink()
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, bool isPhotoBtn) {
    return Obx(() {
      final isSelected = controller.isPhotoMode.value == isPhotoBtn;
      return GestureDetector(
        onTap: () {
          if (!isSelected && !controller.isLoading.value) {
            controller.toggleMode();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellow : Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    });
  }
}