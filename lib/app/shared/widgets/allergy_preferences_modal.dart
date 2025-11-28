import 'package:dietin/app/shared/constants/colors.dart';
import 'package:dietin/app/shared/constants/text_style.dart';
import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:dietin/app/modules/profile_edit/controllers/profile_edit_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class AllergyPreferenceModal extends StatelessWidget {
  final ProfileEditController controller = Get.find();

  AllergyPreferenceModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          SizedBox(height: 24.h),
          Center(child: Text('Preferensi Alergi', style: AppTextStyles.headingAppBar)),
          SizedBox(height: 20.h),

          
          Obx(() {
            final sel = controller.allergies;

            Widget tile(String label, String asset) {
              final active = sel.contains(label);
              return GestureDetector(
                onTap: () => controller.toggleAllergy(label),
                child: Container(
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      width: 1.w,
                      color: active ? AppColors.primary : AppColors.lightGrey,
                    ),
                    color: active
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset(
                          asset,
                          width: 36.r,
                          height: 36.r,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 16.r,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label.copyWith(
                            color: active ? AppColors.primary : Colors.black87,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final itemWidth = (1.sw - 16.w * 2 - 9.w) / 2;

            return Wrap(
              spacing: 9.w,
              runSpacing: 9.h,
              children: controller.allAllergyOptionsWithAssets.entries
                  .map((e) => SizedBox(
                width: itemWidth,
                child: tile(e.key, e.value),
              ))
                  .toList(),
            );
          }),

          SizedBox(height: 28.h),

          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Selesai',
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: AppColors.mainBlack,
              borderRadius: 64,
              textStyle: AppTextStyles.label.copyWith(
                color: AppColors.light,
                fontSize: 18.sp,
              ),
            ),
          ),

          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
