import 'package:dietin/app/data/FoodLogModel.dart';
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/horizontal_progress_bar.dart';
import 'package:dietin/app/shared/widgets/nutrient_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.loadDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 11.h),

                  
                  Obx(() {
                    final isLoading = controller.isLoading.value;
                    final user = controller.user.value;
                    final error = controller.errorMessage.value;

                    String displayName = 'Pengguna';
                    if (!isLoading && error.isEmpty && user != null) {
                      displayName = user.name;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30.r,
                              backgroundImage: const AssetImage(
                                'assets/images/male_ic.png',
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                            SizedBox(width: 10.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Selamat datang! ',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                    Image.asset(
                                      'assets/images/hand_ic.png',
                                      width: 14.w,
                                      height: 14.h,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  displayName,
                                  style: AppTextStyles.bodySmallSemiBold,
                                ),
                              ],
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor: AppColors.mainWhite,
                          child: IconButton(
                            onPressed: () {
                              Get.toNamed('/notification');
                            },
                            icon: SvgPicture.asset(
                              'assets/images/notif_ic.svg',
                              width: 25.w,
                              height: 25.h,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 24.h),
                  Text('Asupan Harian', style: AppTextStyles.labelBold),
                  SizedBox(height: 16.h),

                  
                  Obx(() {
                    return Column(
                      children: [
                        CaloriePill(
                          title: 'Kalori',
                          current: controller.totalCaloriesConsumed.value,
                          target: controller.targetCalories,
                          bg: AppColors.calorieBackgroundActive.withValues(alpha: 0.5),
                          fill: AppColors.calorieBackgroundActive,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: NutrientCard(
                                title: 'Karbo',
                                unit: 'g',
                                current: controller.totalCarbsConsumed.value,
                                target: controller.targetCarbs,
                                bg: const Color(0xFFE2A16F).withValues(alpha: 0.5),
                                fill: const Color(0xFFE2A16F),
                                asset: 'assets/images/carb_ic.png',
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: NutrientCard(
                                title: 'Protein',
                                unit: 'g',
                                current: controller.totalProteinConsumed.value,
                                target: controller.targetProtein,
                                bg: const Color(0xFFDA6C6C).withValues(alpha: 0.5),
                                fill: const Color(0xFFDA6C6C),
                                asset: 'assets/images/protein_ic.png',
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: NutrientCard(
                                title: 'Lemak',
                                unit: 'g',
                                current: controller.totalFatConsumed.value,
                                target: controller.targetFat,
                                bg: const Color(0xFF9BB4C0).withValues(alpha: 0.5),
                                fill: const Color(0xFF9BB4C0),
                                asset: 'assets/images/fat_ic.png',
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 24.h),
                  Text('Tambah Makanan', style: AppTextStyles.labelBold),
                  SizedBox(height: 16.h),

                  
                  Obx(() => _buildMealSection(
                    title: 'Sarapan',
                    iconAsset: 'assets/images/sunrise_ic.svg',
                    log: controller.breakfastLog.value,
                    mealTypeForNav: 'Breakfast',
                  )),
                  SizedBox(height: 9.h),

                  Obx(() => _buildMealSection(
                    title: 'Makan Siang',
                    iconAsset: 'assets/images/sun_ic.svg',
                    log: controller.lunchLog.value,
                    mealTypeForNav: 'Lunch',
                  )),
                  SizedBox(height: 9.h),

                  Obx(() => _buildMealSection(
                    title: 'Makan Malam',
                    iconAsset: 'assets/images/sunset_ic.svg',
                    log: controller.dinnerLog.value,
                    mealTypeForNav: 'Dinner',
                  )),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSection({
    required String title,
    required String iconAsset,
    required FoodLogModel? log,
    required String mealTypeForNav,
  }) {
    final bool hasData = log != null && log.items.isNotEmpty;

    if (hasData) {
      final Map<int, FoodLogItemModel> groupedItems = {};

      for (var item in log.items) {
        final foodId = item.foodId;
        if (groupedItems.containsKey(foodId)) {
          final existing = groupedItems[foodId]!;
          groupedItems[foodId] = FoodLogItemModel(
            id: existing.id, 
            foodId: foodId,
            servings: existing.servings + item.servings, 
            calories: existing.calories + item.calories, 
            food: existing.food, 
          );
        } else {
          
          groupedItems[foodId] = item;
        }
      }

      final displayList = groupedItems.values.toList();

      final sectionCalories = log.items.fold(0, (sum, item) => sum + item.calories);

      return Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(iconAsset, width: 24.w, height: 24.h),
                    ),
                    SizedBox(width: 12.w),
                    Text(title, style: AppTextStyles.bodySmallSemiBold),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$sectionCalories', style: AppTextStyles.bodySmallSemiBold),
                        Text('kalori', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        onPressed: () {
                          Get.toNamed('/search-food', arguments: {'mealType': mealTypeForNav});
                        },
                        icon: Icon(Icons.add_rounded, color: AppColors.mainWhite, size: 20.sp),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Divider(color: AppColors.lightGrey.withValues(alpha: 0.3), thickness: 1),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayList.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = displayList[index];
                final foodName = item.food?.name ?? 'Makanan';

                String servingText = item.servings % 1 == 0
                    ? item.servings.toInt().toString()
                    : item.servings.toString();

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(foodName, style: AppTextStyles.bodySmallSemiBold),
                            SizedBox(height: 4.h),
                            Text('$servingText Porsi', style: AppTextStyles.bodyLight),
                          ],
                        ),
                      ),
                      
                      Text('${item.calories} kkal', style: AppTextStyles.bodyLight),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset(iconAsset, width: 24.w, height: 24.h),
                ),
                SizedBox(width: 12.w),
                Text(title, style: AppTextStyles.bodySmallSemiBold),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('-', style: AppTextStyles.bodySmallSemiBold),
                    Text('kalori', style: AppTextStyles.bodySmall),
                  ],
                ),
                SizedBox(width: 12.w),
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    onPressed: () {
                      Get.toNamed('/search-food', arguments: {'mealType': mealTypeForNav});
                    },
                    icon: Icon(Icons.add_rounded, color: AppColors.mainWhite),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}