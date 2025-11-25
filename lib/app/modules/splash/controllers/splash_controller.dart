import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final GetStorage _storage = GetStorage();

  static const String _initialCompletedKey = 'initial_health_completed';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () {
      final bool hasSeenOnboarding =
          _storage.read(_hasSeenOnboardingKey) == true;
      final bool isLoggedIn = _storage.read(_isLoggedInKey) == true;
      final bool isInitialCompleted =
          _storage.read(_initialCompletedKey) == true;

      final String? accessToken = _storage.read<String>(_accessTokenKey);
      final String? refreshToken = _storage.read<String>(_refreshTokenKey);

      // debug log / print token dan status
      print('[Splash] hasSeenOnboarding=$hasSeenOnboarding');
      print('[Splash] isLoggedIn=$isLoggedIn');
      print('[Splash] isInitialCompleted=$isInitialCompleted');
      print('[Splash] accessToken=$accessToken');
      print('[Splash] refreshToken=$refreshToken');

      Get.log(
        '[Splash] hasSeenOnboarding=$hasSeenOnboarding '
            'isLoggedIn=$isLoggedIn isInitialCompleted=$isInitialCompleted '
            'accessToken=$accessToken refreshToken=$refreshToken',
      );

      // 1. Jika sudah login, lewati onboarding
      if (isLoggedIn) {
        if (isInitialCompleted) {
          Get.offNamed('/botnavbar');
        } else {
          Get.offNamed('/initialhealth');
        }
        return;
      }

      // 2. Belum login: cek apakah sudah pernah lihat onboarding
      if (!hasSeenOnboarding) {
        Get.offNamed('/onboarding');
      } else {
        Get.offNamed('/login');
      }
    });
  }
}
