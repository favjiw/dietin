import 'dart:ui';

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
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    List steps = controller.steps;
    List nutritionFacts = controller.nutritionFacts;
    List ingredients = controller.ingridients;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 400.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTec8zUfRIhICBszXhD7Fv7jAyTKRe7dkAYpQ&s',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: Container(
                  color: Colors.black.withValues(alpha: 0),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 56.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(
                  height: 16.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(26.r),
                  child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTec8zUfRIhICBszXhD7Fv7jAyTKRe7dkAYpQ&s', width: 251.w, height: 200.h, fit: BoxFit.cover,),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  width: double.infinity,
                  // min height
                  constraints: BoxConstraints(
                    minHeight: 500.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //main row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //left item
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: Text(
                                      'Pizza Pizza Keju',
                                      // maxLines: 2,
                                      overflow: TextOverflow.visible,
                                      style: AppTextStyles.foodTitle
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w,
                                            vertical: 3.h
                                        ),
                                        decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(16.r)
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Rekomendasi', style: AppTextStyles.recom,),
                                            SizedBox(width: 10.w,),
                                            SvgPicture.asset(
                                              'assets/images/recom_ic.svg',
                                              width: 12.w,
                                              height: 12.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6.w,),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w,
                                            vertical: 3.h
                                        ),
                                        decoration: BoxDecoration(
                                            color: AppColors.yellow,
                                            borderRadius: BorderRadius.circular(16.r)
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Alergi', style: AppTextStyles.recom,),
                                            SizedBox(width: 10.w,),
                                            SvgPicture.asset(
                                              'assets/images/warning_ic.svg',
                                              width: 12.w,
                                              height: 12.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //right item
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: AppColors.mainWhite,
                              child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  'assets/images/share_ic.svg',
                                  width: 25.w,
                                  height: 25.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h,),
                        Text('Informasi Nutrisi', style: AppTextStyles.foodLabel,),
                        SizedBox(height: 6.h,),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.mainWhite,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          // child: Text('Tes'),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: nutritionFacts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text('name', style: AppTextStyles.bodySmall,),
                                      // Text('value', style: AppTextStyles.bodySmall,),
                                      Text(nutritionFacts[index]['name'], style: AppTextStyles.bodySmall,),
                                      Text(nutritionFacts[index]['value'], style: AppTextStyles.bodySmall,),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 18.h,),
                        Text('Bahan', style: AppTextStyles.foodLabel,),
                        SizedBox(height: 6.h,),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.mainWhite,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text('name', style: AppTextStyles.bodySmall,),
                                      // Text('value', style: AppTextStyles.bodySmall,),
                                      Text(ingredients[index]['name'], style: AppTextStyles.bodySmall,),
                                      Text(ingredients[index]['quantity'], style: AppTextStyles.bodySmall,),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Text('Cara Membuat', style: AppTextStyles.foodLabel),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.mainWhite,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: 6,
                            itemBuilder: (context, index) {

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Numbering untuk langkah utama
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 24.w,
                                        height: 24.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary, // Ganti dengan warna primary Anda
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
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          steps[index]['title'],
                                          style: AppTextStyles.bodySmall
                                      ),
                                      )],
                                  ),
                                  SizedBox(height: 8.h),

                                  ...steps[index]['substeps'].map<Widget>((substep) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 32.w, bottom: 4.h), // Indentasi
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '• ',
                                            style: AppTextStyles.bodySmall,
                                          ),
                                          Expanded(
                                            child: Text(
                                              substep,
                                              style: AppTextStyles.bodySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),

                                  SizedBox(height: 16.h), // Spasi antar langkah
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
