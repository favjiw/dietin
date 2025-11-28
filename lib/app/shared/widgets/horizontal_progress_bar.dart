import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaloriePill extends StatelessWidget {
  final String title;
  final int current;
  final int target;
  final Color bg;
  final Color fill;

  const CaloriePill({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.bg,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    final p = (current / target).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: 96,
        child: Stack(
          children: [
            
            Container(color: bg),
            
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: p,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(color: fill),
                ),
              ),
            ),
            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15.r,
                    backgroundColor: AppColors.mainWhite,
                    child: Image.asset(
                      'assets/images/fire_ic.png',
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                  Text(title, style: AppTextStyles.calorieActive),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${current}g', style: AppTextStyles.calorieActive),
                      Text(' / ', style: AppTextStyles.calorieInactive),
                      Text('${target}g', style: AppTextStyles.calorieInactive),
                    ],
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
