import 'package:flutter/material.dart';
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: iconColor ?? AppColors.darkGrey),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: labelColor ?? AppColors.darkGrey),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }
}
