import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CamController extends GetxController {
  // Flag untuk mode: True = Photo, False = Scan
  var isPhotoMode = true.obs;

  // Controller untuk Camera package (Ambil Foto)
  CameraController? cameraController;
  List<CameraDescription>? _cameras; // Cache list kamera
  var isCameraInitialized = false.obs;

  // Controller untuk MobileScanner (Scan Barcode)
  MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    scannerController.dispose();
    super.onClose();
  }

  // Ganti Mode dengan manajemen lifecycle yang aman
  Future<void> toggleMode() async {
    if (isPhotoMode.value) {
      // Beralih ke SCAN MODE
      // Matikan kamera foto terlebih dahulu untuk melepas resource hardware
      isCameraInitialized.value = false;
      await cameraController?.dispose();
      cameraController = null;

      // Update UI ke mode scan
      isPhotoMode.value = false;
    } else {
      // Beralih ke PHOTO MODE
      // Update UI dulu agar Scanner widget di-unmount
      isPhotoMode.value = true;

      // Inisialisasi ulang kamera foto
      await _initializeCamera();
    }
  }

  // Inisialisasi Kamera Native
  Future<void> _initializeCamera() async {
    try {
      // Cek apakah list kamera sudah pernah diambil
      if (_cameras == null) {
        _cameras = await availableCameras();
      }

      if (_cameras != null && _cameras!.isNotEmpty) {
        // Pilih kamera belakang (biasanya index 0)
        cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController!.initialize();

        // Cek jika controller sudah ditutup saat proses inisialisasi berjalan
        if (isClosed) return;

        isCameraInitialized.value = true;
      } else {
        Get.snackbar("Error", "Kamera tidak ditemukan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal inisialisasi kamera: $e");
    }
  }

  // Fungsi Ambil Foto
  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (cameraController!.value.isTakingPicture) {
      return;
    }

    try {
      final XFile image = await cameraController!.takePicture();

      // Simpan path atau kirim ke halaman selanjutnya
      Get.snackbar("Sukses", "Foto disimpan di: ${image.path}");

      // TODO: Navigasi ke halaman preview/upload dengan membawa path gambar
      // Get.toNamed(Routes.PREVIEW, arguments: image.path);

    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil foto: $e");
    }
  }

  // Callback saat Barcode terdeteksi
  void onBarcodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        Get.snackbar("Scan Berhasil", "Kode: ${barcode.rawValue}");
        // Stop scan sementara agar tidak spam notif
        scannerController.stop();
        // TODO: Lakukan sesuatu dengan hasil scan, misal cari makanan by barcode
      }
    }
  }
}