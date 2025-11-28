import 'package:dietin/app/modules/home/views/home_view.dart';
import 'package:dietin/app/modules/meals/views/meals_view.dart';
import 'package:dietin/app/modules/profile/views/profile_view.dart';
import 'package:dietin/app/modules/statistics/views/statistics_view.dart';
import 'package:dietin/app/routes/app_pages.dart'; 
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/botnavbar_controller.dart';

class BotnavbarView extends GetView<BotnavbarController> {
  const BotnavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      HomeView(),
      MealsView(),
      SizedBox(), 
      StatisticsView(),
      ProfileView(),
    ];

    return Obx(
          () => Scaffold(
        backgroundColor: AppColors.secondaryWhite,
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: SizedBox(
          width: 1.sw,
          height: 100.h,
          child: Stack(
            children: [
              Positioned(
                bottom: 0.h,
                left: 0.w,
                child: Container(
                  width: 1.sw,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.mainWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.r),
                      topRight: Radius.circular(32.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.currentIndex.value = 0;
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              controller.currentIndex.value == 0
                                  ? 'assets/images/home_act_ic.svg'
                                  : 'assets/images/home_inac_ic.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Home',
                              style: controller.currentIndex.value == 0
                                  ? AppTextStyles.botnavActive
                                  : AppTextStyles.botnavInactive,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.currentIndex.value = 1;
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              controller.currentIndex.value == 1
                                  ? 'assets/images/meals_act_ic.svg'
                                  : 'assets/images/meals_inac_ic.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Meals',
                              style: controller.currentIndex.value == 1
                                  ? AppTextStyles.botnavActive
                                  : AppTextStyles.botnavInactive,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 24.w, height: 24.h), 
                      InkWell(
                        onTap: () {
                          controller.currentIndex.value = 3;
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              controller.currentIndex.value == 3
                                  ? 'assets/images/stats_act_ic.svg'
                                  : 'assets/images/stats_inac_ic.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Stats',
                              style: controller.currentIndex.value == 3
                                  ? AppTextStyles.botnavActive
                                  : AppTextStyles.botnavInactive,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.currentIndex.value = 4;
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              controller.currentIndex.value == 4
                                  ? 'assets/images/profile_act_ic.svg'
                                  : 'assets/images/profile_inac_ic.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Profile',
                              style: controller.currentIndex.value == 4
                                  ? AppTextStyles.botnavActive
                                  : AppTextStyles.botnavInactive,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.mainWhite,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: InkWell(
                    
                    
                    
                    onTap: () {
                      Get.toNamed(Routes.CAM);
                    },
                    child: Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: AppColors.mainBlack,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/scan_ic.svg',
                          width: 32.w,
                          height: 32.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}