import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
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
      body: Stack(
        children: [
          Positioned(
            bottom: 290.h,
            right: -30,
            child: Image.asset(
              'assets/images/green_right_img.png',
              width: 135.w,
              height: 156.h,
            ),
          ),
          Positioned(
            bottom: 290.h,
            left: -30,
            child: Image.asset(
              'assets/images/green_left_img.png',
              width: 135.w,
              height: 156.h,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              width: double.infinity,
              height: 340.h,
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              decoration: BoxDecoration(
                color: AppColors.mainWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 55.h),
                  Text('Makan Cerdas!', style: AppTextStyles.onboardBigTitle,),
                  SizedBox(height: 19.h),
                  Text('Nikmati hidup lebih seimbang dengan pola makan yang teratur.', textAlign: TextAlign.center, style: AppTextStyles.onboardBigSubtitle,),
                  SizedBox(height: 78.h,),
                  CustomButton(
                    text: 'Mulai',
                    onPressed: () {
                      controller.start();
                    },
                    backgroundColor: AppColors.mainBlack,
                    borderRadius: 64,
                    textStyle: AppTextStyles.label.copyWith(
                      color: AppColors.light,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 310.h,
            left: 32.w,
            child: Image.asset(
              'assets/images/girl_onboard_img.png',
              width: 296.11.w,
              height: 439.h,
            ),
          ),
        ],
      ),
    );
  }
}
