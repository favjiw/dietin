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
    final List<Map<String, String>> foods = [
      {
        'name': 'Nasi Goreng (Sukarasa)',
        'portion': '100 gram (g)',
        'calorie': '400 kkal',
      },
      {
        'name': 'Nasi Goreng (Betuah)',
        'portion': '100 gram (g)',
        'calorie': '490 kkal',
      },
      {
        'name': 'Nasi Goreng (ITHB)',
        'portion': '100 gram (g)',
        'calorie': '400 kkal',
      },
      {
        'name': 'Nasi Goreng Spesial (Tianlala)',
        'portion': '100 gram (g)',
        'calorie': '560 kkal',
      },
      {
        'name': 'Nasi Goreng Hitam (Bingung)',
        'portion': '100 gram (g)',
        'calorie': '390 kkal',
      },
      {
        'name': 'Nasi Lupa Goreng (Njir)',
        'portion': '100 gram (g)',
        'calorie': '400 kkal',
      },
    ];
    controller.initCheckList(foods.length);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.mainWhite,
        appBar: AppBar(
          title: Text('Tambah Makanan', style: AppTextStyles.headingAppBar),
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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
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
                  //If Search Result Not Empty
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return Obx(() =>
                        InkWell(
                        onTap: () {
                          controller.toggleCheck(index);
                        },
                        child: Container(
                          width: 1.sw,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.lightGrey,
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
                                      food['name'] ?? '',
                                      style: AppTextStyles.labelSearch,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${food['portion']} ',
                                            style: AppTextStyles.bodyLight
                                                .copyWith(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          TextSpan(
                                            text: food['calorie'] ?? '',
                                            style: AppTextStyles.bodyLight,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  border: Border.all(
                                    color: controller.checkedList[index]
                                        ? AppColors.primary
                                        : AppColors.lightGrey,
                                    width: 1.5,
                                  ),
                                  color: controller.checkedList[index]
                                      ? AppColors.primary.withValues(alpha: 0.2)
                                      : Colors.transparent,
                                ),
                                child: controller.checkedList[index]
                                    ? Icon(
                                  Icons.check,
                                  size: 16.w,
                                  color: AppColors.primary,
                                )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ));
                    },
                  ),
                  //If Empty
                  // Center(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image.asset('assets/images/empty_img.png', width: 250.w, height: 250.h,),
                  //       Text('Riwayat makanan masih kosong', style: AppTextStyles.bodyLight,),
                  //     ],
                  //   ),
                  // ),
                  //If history available
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: 15,
                  //   itemBuilder: (context, index) {
                  //     return InkWell(
                  //       onTap: () {},
                  //       child: Container(
                  //         width: 1.sw,
                  //         padding: EdgeInsets.symmetric(vertical: 16.h),
                  //         decoration: BoxDecoration(
                  //           border: Border(
                  //             bottom: BorderSide(
                  //               color: AppColors.lightGrey,
                  //               width: 1,
                  //             ),
                  //           ),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             //first row
                  //             Row(
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 SvgPicture.asset(
                  //                   'assets/images/history_ic.svg',
                  //                   width: 24.w,
                  //                   height: 24.h,
                  //                 ),
                  //                 SizedBox(width: 12.w),
                  //                 Text(
                  //                   'Nasi Putih',
                  //                   style: AppTextStyles.labelSearch,
                  //                 ),
                  //               ],
                  //             ),
                  //             //second row
                  //             SvgPicture.asset(
                  //               'assets/images/arrow_up_left_ic.svg',
                  //               width: 24.w,
                  //               height: 24.h,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          backgroundColor: AppColors.primary,
          onPressed: () {},
          child: SvgPicture.asset(
            'assets/images/scan_ic.svg',
            width: 32.w,
            height: 32.h,
          ),
      ),
    ));
  }
}
