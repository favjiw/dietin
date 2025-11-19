import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/meals_controller.dart';

class MealsView extends GetView<MealsController> {
  const MealsView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.secondaryWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 11.h),
                  Center(
                    child: Text('Makanan', style: AppTextStyles.headingAppBar),
                  ),
                  SizedBox(height: 17.h),
                  CustomTextField(
                    fillColor: AppColors.mainWhite,
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
                  SizedBox(height: 30.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed('/detail-food');
                            },
                            child: Container(
                              width: 1.sw,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 10.h,
                              ),
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: AppColors.mainWhite,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              // main row
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //     left row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25.r,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTec8zUfRIhICBszXhD7Fv7jAyTKRe7dkAYpQ&s',
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pizza Mozarella',
                                            style: AppTextStyles.labelBold,
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/fire_ic.svg',
                                                width: 13.w,
                                                height: 18.h,
                                              ),
                                              SizedBox(width: 2.w,),
                                              Text(
                                                '120 kkal',
                                                style: AppTextStyles.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                //   right column
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                      SizedBox(height: 12.h,),
                                      Text('100 gr', style: AppTextStyles.bodyLight,)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
