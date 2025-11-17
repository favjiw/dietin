import 'package:dietin/app/shared/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NutrientCard extends StatelessWidget {
  final String title;
  final String unit;
  final int current;
  final int target;
  final Color bg;
  final Color fill;
  final String asset;

  const NutrientCard({
    super.key,
    required this.title,
    required this.unit,
    required this.current,
    required this.target,
    required this.bg,
    required this.fill,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    final p = (current / target).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          children: [
            Container(color: bg),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: p,
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: fill,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            // konten
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),
                  Center(
                    child: CircleAvatar(
                      radius: 15.r,
                      backgroundColor: AppColors.mainWhite,
                      child: Image.asset(
                        asset,
                        width: 18.w,
                        height: 18.h,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.carbsActive,
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.carbsActive,
                          children: [
                            TextSpan(text: '$current$unit'),
                            TextSpan(
                              text: ' / $target$unit',
                              style: AppTextStyles.carbsInactive,
                            )],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}