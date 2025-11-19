import 'package:flutter/material.dart';
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const PersonalInfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.w,
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 11.w),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.profileLabel),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTextStyles.headingAppBar),
              SizedBox(width: 4.w),
              Text(unit, style: AppTextStyles.profileUnit),
            ],
          ),
        ],
      ),
    );
  }
}
