import 'package:dietin/app/modules/profile_edit/controllers/profile_edit_controller.dart';
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllergyPreferenceModal extends StatelessWidget {
  final ProfileEditController controller = Get.find();

  AllergyPreferenceModal({super.key});

  Widget _buildAllergyButton(String allergy) {
    final bool selected = controller.allergies.contains(allergy);

    return OutlinedButton.icon(
      onPressed: () {
        if (selected) {
          controller.removeAllergy(allergy);
        } else {
          controller.addAllergy(allergy);
        }
      },
      icon: _allergyIcon(allergy),
      label: Text(allergy, style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: selected ? Colors.teal : Colors.grey),
        backgroundColor: selected ? Colors.teal[100] : Colors.transparent,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _allergyIcon(String allergy) {
    // Use emojis as fallback icons
    switch (allergy) {
      case 'Susu, Telur, dan Produk Susu Lainnya':
        return const Icon(Icons.local_drink, size: 18, color: Colors.teal);
      case 'Roti / Olahan Roti':
        return const Icon(Icons.bakery_dining, size: 18, color: Colors.teal);
      case 'Daging':
        return const Icon(Icons.set_meal, size: 18, color: Colors.teal);
      case 'Udang':
        return const Icon(Icons.set_meal, size: 18, color: Colors.teal);
      case 'Kacang':
        return const Icon(Icons.spa, size: 18, color: Colors.teal);
      case 'Teh dan Kopi':
        return const Icon(Icons.local_cafe, size: 18, color: Colors.teal);
      case 'Kedelai':
        return const Icon(Icons.grain, size: 18, color: Colors.teal);
      case 'Wijen':
        return const Icon(Icons.grain, size: 18, color: Colors.teal);
      case 'Ikan':
        return const Icon(Icons.set_meal, size: 18, color: Colors.teal);
      default:
        return const Icon(Icons.help_outline, size: 18, color: Colors.teal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allergies = controller.allAllergyOptions;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 34.h),
          Text('Preferensi Alergi', style: AppTextStyles.headingAppBar),
          SizedBox(height: 34.h),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allergies.map(_buildAllergyButton).toList(),
          ),
          SizedBox(height: 34.h),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Selesai',
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: AppColors.mainBlack,
              borderRadius: 64,
              textStyle: AppTextStyles.label.copyWith(
                color: AppColors.light,
                fontSize: 18.sp,
              ),
            ),
            // child: ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     padding: const EdgeInsets.symmetric(vertical: 14),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            //   ),
            //   child: const Text('Selesai', style: TextStyle(fontSize: 16)),
            // ),
          ),
        ],
      ),
    );
  }
}
