import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchFoodController extends GetxController {
  TextEditingController searchController = TextEditingController();

  // misal jumlah item dynamic, bisa dari API / list makanan
  // untuk sekarang sementara kosong dulu, nanti diset setelah list makanan dibuat
  RxList<bool> checkedList = <bool>[].obs;

  // panggil ini setelah data makanan di-load
  void initCheckList(int length) {
    checkedList = List.generate(length, (_) => false).obs;
  }

  // toggle checkbox
  void toggleCheck(int index) {
    checkedList[index] = !checkedList[index];
  }

  // ambil list makanan yang dicentang
  List<int> get selectedIndexes {
    return List.generate(checkedList.length, (i) => i)
        .where((i) => checkedList[i])
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
