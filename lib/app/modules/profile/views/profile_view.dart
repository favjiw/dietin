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
        child: Obx(
              () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // indikator loading (opsional, tidak menutupi konten)
                if (controller.isLoading.value)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Memuat profil...',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),

                // tampilan error singkat, tapi konten tetap tampil
                if (controller.errorMessage.value.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Gagal memuat profil. Kamu tetap bisa logout dari sini.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                // kartu profil utama
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
                                backgroundImage: const NetworkImage(
                                  'https://picsum.photos/100/100',
                                ),
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
                                    border: Border.all(
                                      color: AppColors.mainWhite,
                                      width: 2.w,
                                    ),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              minimumSize: Size(80.w, 36.h),
                            ),
                            child: Text(
                              'Edit Info',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16.sp,
                            color: AppColors.lightGrey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            controller.timeZone.value,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 11.h),
                      Text(
                        controller.name.value,
                        style: AppTextStyles.headingAppBar,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // cards info pribadi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PersonalInfoCard(
                      label: 'Tinggi badan',
                      value: controller.height.value.toString(),
                      unit: 'CM',
                    ),
                    PersonalInfoCard(
                      label: 'Berat badan',
                      value: controller.weight.value.toString(),
                      unit: 'KG',
                    ),
                    PersonalInfoCard(
                      label: 'Umur',
                      value: controller.age.value.toString(),
                      unit: 'Tahun',
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // menu list termasuk logout
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
                          controller.logout();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
