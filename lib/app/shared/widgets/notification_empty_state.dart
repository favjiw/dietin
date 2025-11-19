import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ganti dengan Image.asset sesuai asset-mu
            SizedBox(
              width: 200.w,
              height: 200.w,
              child: Image.asset(
                'assets/images/notification_empty_img.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Belum ada notifikasi',
              style: AppTextStyles.labelBold.copyWith(fontSize: 20.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                'Notifikasi akan muncul di sini ketika kamu menerimanya.',
                style: AppTextStyles.bodyLight.copyWith(
                  color: AppColors.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
