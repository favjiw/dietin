import 'package:dietin/app/routes/app_pages.dart';
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/search_food_controller.dart';

class SearchFoodView extends GetView<SearchFoodController> {
  const SearchFoodView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Map MealType ke Bahasa Indonesia untuk judul
    String title = 'Tambah Makanan';
    // Akses aman ke mealType, gunakan default jika belum diinisialisasi (walaupun onInit sudah handle)
    try {
      if (controller.mealType == 'Breakfast') title = 'Tambah Sarapan';
      if (controller.mealType == 'Lunch') title = 'Tambah Makan Siang';
      if (controller.mealType == 'Dinner') title = 'Tambah Makan Malam';
    } catch (_) {}

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.mainWhite,
        appBar: AppBar(
          title: Text(title, style: AppTextStyles.headingAppBar),
          backgroundColor: AppColors.mainWhite,
          surfaceTintColor: AppColors.mainWhite,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.mainBlack,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            // Tombol Simpan di AppBar (Icon Ceklis)
            Obx(() {
              if (controller.isSubmitting.value) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)
                  ),
                );
              }

              // Tampilkan ceklis hanya jika ada yang dipilih
              // selectedCount adalah getter yang mengakses selectedItems, jadi reaktif di dalam Obx
              if (controller.selectedCount > 0) {
                return IconButton(
                  onPressed: () => controller.submitLog(),
                  icon: Icon(Icons.check_rounded, color: AppColors.primary, size: 28.sp),
                );
              }

              return SizedBox.shrink();
            })
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Cari makanan...',
                      controller: controller.searchController,
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.h,
                          vertical: 10.w,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/search_ic.svg',
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 13.h),
                  ],
                ),
              ),

              // List Makanan (Expanded agar scrollable dan mengisi sisa ruang)
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredFoods.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/empty_img.png', width: 200.w, height: 200.h),
                          SizedBox(height: 16.h),
                          Text('Makanan tidak ditemukan', style: AppTextStyles.bodyLight),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: controller.filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = controller.filteredFoods[index];

                      // BUNGKUS ITEM DENGAN OBX AGAR REAKTIF PER ITEM
                      return Obx(() {
                        final isChecked = controller.isSelected(food.id);

                        return InkWell(
                          onTap: () {
                            controller.toggleSelection(food.id);
                          },
                          child: Container(
                            width: 1.sw,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.lightGrey.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: AppTextStyles.labelSearch,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              // Updated: Menggunakan servingType jika tersedia, default 'Porsi'
                                              text: '${food.servings ?? 1} ${food.servingType ?? 'Porsi'} ',
                                              style: AppTextStyles.bodyLight.copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${food.calories} kkal', // Asumsi helper calories ada di FoodModel
                                              style: AppTextStyles.bodyLight,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                // Checkbox Custom
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24.w,
                                  height: 24.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: isChecked
                                          ? AppColors.primary
                                          : AppColors.lightGrey,
                                      width: 2,
                                    ),
                                    color: isChecked
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                  child: isChecked
                                      ? Icon(
                                    Icons.check,
                                    size: 16.w,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        // Floating Action Button (Scan) tetap dipertahankan jika perlu
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          backgroundColor: AppColors.primary,
          onPressed: () {
            Get.toNamed(Routes.CAM);
          },
          child: SvgPicture.asset(
            'assets/images/scan_ic.svg',
            width: 32.w,
            height: 32.h,
          ),
        ),
      ),
    );
  }
}