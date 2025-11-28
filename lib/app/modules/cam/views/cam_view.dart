import 'package:camera/camera.dart';
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
          // LAYER 1: KAMERA / SCANNER PREVIEW
          Obx(() {
            if (controller.isPhotoMode.value) {
              // Tampilan Mode FOTO
              if (controller.isCameraInitialized.value &&
                  controller.cameraController != null) {
                return SizedBox(
                  width: 1.sw,
                  height: 1.sh,
                  child: CameraPreview(controller.cameraController!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            } else {
              // Tampilan Mode SCAN
              return MobileScanner(
                controller: controller.scannerController,
                onDetect: controller.onBarcodeDetect,
                fit: BoxFit.cover,
                // Overlay kotak fokus scan (opsional)
                overlayBuilder: (context, constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: 50.w,
                        vertical: 0.25.sh
                    ),
                  );
                },
              );
            }
          }),

          // LAYER 2: TOMBOL KEMBALI (POJOK KIRI ATAS)
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

          // LAYER 3: CONTROLS (BAWAH)
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Selector Mode (Photo / Scan)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildModeButton("Photo", true),
                      SizedBox(width: 10.w),
                      _buildModeButton("Scan", false),
                    ],
                  )),
                ),

                SizedBox(height: 20.h),

                // Tombol Shutter (Hanya muncul di mode Foto)
                Obx(() {
                  if (controller.isPhotoMode.value) {
                    return GestureDetector(
                      onTap: () => controller.takePicture(),
                      child: Container(
                        width: 70.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 4),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(height: 70.h); // Spacer saat mode scan
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, bool isPhoto) {
    bool isActive = controller.isPhotoMode.value == isPhoto;
    return GestureDetector(
      onTap: () {
        if (!isActive) controller.toggleMode();
      },
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.yellow : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}