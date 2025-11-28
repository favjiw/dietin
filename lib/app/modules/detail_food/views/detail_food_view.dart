import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/detail_food_controller.dart';

class DetailFoodView extends GetView<DetailFoodController> {

  const DetailFoodView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, 
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Obx(() {
        if (controller.isLoading.value && controller.food.value == null) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        final food = controller.food.value;
        if (food == null) {
          return const Center(child: Text("Data makanan tidak ditemukan", style: TextStyle(color: Colors.white)));
        }

        return SingleChildScrollView(
          child: Stack(
            children: [
              
              Container(
                height: 400.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (food.imageUrl != null && food.imageUrl!.isNotEmpty)
                        ? NetworkImage(food.imageUrl!)
                        : const AssetImage('assets/images/empty_img.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  SizedBox(height: 56.h),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppColors.mainWhite,
                        ),
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor: AppColors.mainWhite,
                          child: Obx(() => IconButton(
                            onPressed: () {
                              controller.toggleFavorite();
                            },
                            icon: SvgPicture.asset(
                              'assets/images/love_ic.svg',
                              width: 25.w,
                              height: 25.h,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                controller.isFavorite.value
                                    ? Colors.red
                                    : AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),

                  
                  SizedBox(height: 220.h), 

                  
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: 500.h, 
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name,
                                      overflow: TextOverflow.visible,
                                      style: AppTextStyles.foodTitle,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        if (food.prepTime != null)
                                          _buildTag(
                                              '${food.prepTime} min',
                                              AppColors.primary,
                                              Icons.timer_outlined
                                          ),
                                        if (food.servings != null)
                                          Padding(
                                            padding: EdgeInsets.only(left: 6.w),
                                            child: _buildTag(
                                              
                                                '${food.servings} ${food.servingType ?? 'porsi'}',
                                                AppColors.yellow,
                                                Icons.restaurant_menu
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: AppColors.mainWhite,
                                child: IconButton(
                                  onPressed: () {
                                    
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/images/share_ic.svg',
                                    width: 25.w,
                                    height: 25.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          
                          if (food.nutritionFacts.isNotEmpty) ...[
                            Text('Informasi Nutrisi', style: AppTextStyles.foodLabel),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColors.mainWhite,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Column(
                                children: food.nutritionFacts.map((fact) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(fact.name, style: AppTextStyles.bodyLight),
                                        Text(fact.value, style: AppTextStyles.bodySmallSemiBold),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],

                          
                          if (food.ingredients.isNotEmpty) ...[
                            Text('Bahan', style: AppTextStyles.foodLabel),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColors.mainWhite,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Column(
                                children: food.ingredients.map((ing) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ing.name, style: AppTextStyles.bodySmall),
                                        Text(ing.quantity, style: AppTextStyles.bodyLight),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],

                          
                          if (food.steps.isNotEmpty) ...[
                            Text('Cara Membuat', style: AppTextStyles.foodLabel),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColors.mainWhite,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: food.steps.length,
                                itemBuilder: (context, index) {
                                  final step = food.steps[index];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 24.w,
                                            height: 24.h,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Text(
                                              step.title,
                                              style: AppTextStyles.bodySmallSemiBold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      if (step.substeps.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(left: 36.w, bottom: 16.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: step.substeps.map((sub) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: 4.h),
                                                child: Text(
                                                  '• $sub',
                                                  style: AppTextStyles.bodyLight,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      else
                                        SizedBox(height: 16.h),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTag(String text, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyles.recom.copyWith(fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}