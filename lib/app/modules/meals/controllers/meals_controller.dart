import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealsController extends GetxController {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
