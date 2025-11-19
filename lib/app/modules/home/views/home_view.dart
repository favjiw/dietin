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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 11.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: AssetImage(
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
                              'John Doe',
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
                ),
                SizedBox(height: 24.h),
                Text('Asupan Harian', style: AppTextStyles.labelBold),
                SizedBox(height: 16.h),
                CaloriePill(
                  title: 'Kalori',
                  current: 1890,
                  target: 2000,
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
                        current: 120,
                        target: 150,
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
                        current: 24,
                        target: 100,
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
                        current: 29,
                        target: 70,
                        bg: const Color(0xFF9BB4C0).withValues(alpha: 0.5),
                        fill: const Color(0xFF9BB4C0),
                        asset: 'assets/images/fat_ic.png',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text('Tambah Makanan', style: AppTextStyles.labelBold),
                SizedBox(height: 16.h),
                //meal container if food exist
                Stack(
                  children: [
                    //open container if food added
                    Container(
                      width: 1.sw,
                      // height: .h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.mainWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //spacing
                          SizedBox(height: 95.h),
                          //food item row
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //food column
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nasi  Putih',
                                            style: AppTextStyles.bodySmallSemiBold,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '100 gr',
                                            style: AppTextStyles.bodyLight,
                                          ),
                                        ],
                                      ),
                                      //calorie row
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '90 kkal',
                                            style: AppTextStyles.bodyLight,
                                          ),
                                          SizedBox(width: 4.w),
                                          InkWell(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.keyboard_arrow_right_rounded,
                                              color: AppColors.lightGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    //main container
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 12.h,
                      ),
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
                      //main row
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //left row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(
                                  'assets/images/sunrise_ic.svg',
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Sarapan',
                                style: AppTextStyles.bodySmallSemiBold,
                              ),
                            ],
                          ),
                          //right row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //calorie column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '355',
                                    style: AppTextStyles.bodySmallSemiBold,
                                  ),
                                  Text(
                                    'kalori',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                              SizedBox(width: 12.w),
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: AppColors.primary,
                                child: IconButton(
                                  onPressed: () {
                                    Get.toNamed('/search-food');
                                  },
                                  icon: Icon(
                                    Icons.add_rounded,
                                    color: AppColors.mainWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //Spacing
                SizedBox(height: 9.h),
                Container(
                  width: 1.sw,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
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
                  //main row
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //left row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.asset(
                              'assets/images/sun_ic.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Makan Siang',
                            style: AppTextStyles.bodySmallSemiBold,
                          ),
                        ],
                      ),
                      //right row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //calorie column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('', style: AppTextStyles.bodySmallSemiBold),
                              Text('', style: AppTextStyles.bodySmall),
                            ],
                          ),
                          SizedBox(width: 12.w),
                          CircleAvatar(
                            radius: 25.r,
                            backgroundColor: AppColors.primary,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_rounded,
                                color: AppColors.mainWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 9.h),
                Container(
                  width: 1.sw,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
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
                  //main row
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //left row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.asset(
                              'assets/images/sunset_ic.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Makan Malam',
                            style: AppTextStyles.bodySmallSemiBold,
                          ),
                        ],
                      ),
                      //right row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //calorie column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('', style: AppTextStyles.bodySmallSemiBold),
                              Text('', style: AppTextStyles.bodySmall),
                            ],
                          ),
                          SizedBox(width: 12.w),
                          CircleAvatar(
                            radius: 25.r,
                            backgroundColor: AppColors.primary,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_rounded,
                                color: AppColors.mainWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
