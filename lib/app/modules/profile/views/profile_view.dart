import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/personal_info_card.dart';
import 'package:dietin/app/shared/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryWhite,
        elevation: 0,
        centerTitle: true,
        title: Text('Profile', style: AppTextStyles.headingAppBar),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.mainWhite,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 32.r,
                            backgroundImage: NetworkImage('https://picsum.photos/100/100'),
                            backgroundColor: AppColors.primary,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14.w,
                              height: 14.w,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.mainWhite, width: 2.w),
                              ),
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Get.toNamed('/profile-edit');
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          minimumSize: Size(80.w, 36.h),
                        ),
                        child: Text('Edit Info', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16.sp, color: AppColors.lightGrey),
                      SizedBox(width: 4.w),
                      Obx(() => Text(controller.timeZone.value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.lightGrey))),
                    ],
                  ),
                  SizedBox(height: 11.h),
                  Obx(() => Text(
                    controller.name.value,
                    style: AppTextStyles.headingAppBar),),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => PersonalInfoCard(
                  label: 'Tinggi badan',
                  value: controller.height.value.toString(),
                  unit: 'CM',
                )),
                Obx(() => PersonalInfoCard(
                  label: 'Berat badan',
                  value: controller.weight.value.toString(),
                  unit: 'KG',
                )),
                Obx(() => PersonalInfoCard(
                  label: 'Umur',
                  value: controller.age.value.toString(),
                  unit: 'Tahun',
                )),
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    label: 'Detail Personal',
                    onTap: () {
                      // Navigate to detail personal
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Pengaturan',
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    label: 'Tentang Kami',
                    onTap: () {
                      // Navigate to about us
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout_outlined,
                    label: 'Keluar',
                    labelColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () {
                      // Logout action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
