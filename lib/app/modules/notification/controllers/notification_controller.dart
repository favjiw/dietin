import 'package:dietin/app/data/NotificationModel.dart';
import 'package:get/get.dart';



class NotificationController extends GetxController {
  final isLoading = true.obs;
  final groups = <NotificationGroup>[].obs;

  // ubah ke true/false untuk simulasi kosong / tidak kosong
  final bool simulateEmpty = true;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    if (simulateEmpty) {
      groups.clear();
    } else {
      groups.assignAll(_dummyGroups);
    }

    isLoading.value = false;
  }

  List<NotificationGroup> get _dummyGroups {
    final now = DateTime.now();

    return [
      NotificationGroup(
        header: 'Hari ini',
        items: [
          NotificationModel(
            id: '1',
            title: 'Dietin',
            message: 'Kalori harian anda masih kurang!',
            date: now,
          ),
        ],
      ),
      NotificationGroup(
        header: 'Kemarin',
        items: [
          NotificationModel(
            id: '2',
            title: 'Dietin',
            message: 'Anda telah melewati batas harian lemak',
            date: now.subtract(const Duration(days: 1)),
          ),
          NotificationModel(
            id: '3',
            title: 'Dietin',
            message: 'Protein harian anda masih kurang!',
            date: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
      NotificationGroup(
        header: '17 November 2025',
        items: [
          NotificationModel(
            id: '4',
            title: 'Dietin',
            message: 'Anda telah memenuhi protein harian!',
            date: DateTime(2025, 11, 17),
          ),
          NotificationModel(
            id: '5',
            title: 'Dietin',
            message: 'Anda telah melewati batas harian karbo',
            date: DateTime(2025, 11, 17),
          ),
          NotificationModel(
            id: '6',
            title: 'Dietin',
            message: 'Jangan lupa makan siang!',
            date: DateTime(2025, 11, 17),
          ),
        ],
      ),
    ];
  }
}
