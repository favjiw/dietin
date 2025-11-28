import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/allergy_preferences_modal.dart';
import 'package:dietin/app/shared/widgets/allergy_tag.dart';
import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:dietin/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/profile_edit_controller.dart';

class ProfileEditView extends GetView<ProfileEditController> {
  const ProfileEditView({super.key});
  @override
  Widget build(BuildContext context) {
    void showAllergyModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AllergyPreferenceModal(),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail Personal', style: AppTextStyles.headingAppBar),
          centerTitle: true,
          backgroundColor: AppColors.light,
          surfaceTintColor: AppColors.light,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: BackButton(color: Colors.black),
          actions: [
            Obx(() {
              if (controller.isLoading.value) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Center(
                    child: SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        backgroundColor: AppColors.secondaryWhite,
        body: Obx(() {
          if (controller.isLoading.value && controller.user.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 100.h), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.primary,
                              
                              backgroundImage: const NetworkImage(
                                'https://picsum.photos/100/100'
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt, size: 20),
                                  onPressed: () {
                                    
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      
                      CustomTextField(
                        labelText: 'Nama Lengkap',
                        hintText: 'Nama Lengkap',
                        keyboardType: TextInputType.text,
                        controller: controller.fullNameController,
                        fillColor: AppColors.mainWhite,
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 13.h,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/pencil_ic.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        labelText: 'Email',
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: controller.emailController,
                        fillColor: AppColors.mainWhite,
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 13.h,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/pencil_ic.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        labelText: 'Tanggal Lahir',
                        hintText: 'Tanggal Lahir (YYYY-MM-DD)',
                        keyboardType: TextInputType.text,
                        controller: controller.birthDateController,
                        fillColor: AppColors.mainWhite,
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 13.h,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/pencil_ic.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        labelText: 'Tinggi Badan (cm)',
                        hintText: 'Tinggi Badan',
                        keyboardType: TextInputType.number,
                        controller: controller.heightController,
                        fillColor: AppColors.mainWhite,
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 13.h,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/pencil_ic.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        labelText: 'Berat Badan (kg)',
                        hintText: 'Berat Badan',
                        keyboardType: TextInputType.number,
                        controller: controller.weightController,
                        fillColor: AppColors.mainWhite,
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 13.h,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/pencil_ic.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Alergi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                            () => Container(
                          width: 380,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.mainWhite,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Wrap(
                            children: [
                              ...controller.allergies.map(
                                    (e) => AllergyTag(
                                  label: e,
                                  onRemove: () => controller.removeAllergy(e),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => showAllergyModal(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h,),
                                  margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: AppColors.mainWhite,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.secondaryWhite,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Obx(() => CustomButton(
                    text: controller.isSaving.value ? 'Menyimpan...' : 'Simpan Perubahan',
                    onPressed: controller.isSaving.value || controller.isLoading.value
                        ? null
                        : controller.updateProfile,
                    backgroundColor: AppColors.mainBlack,
                    borderRadius: 64,
                    textStyle: AppTextStyles.label.copyWith(
                      color: AppColors.light,
                      fontSize: 18.sp,
                    ),
                  )),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}