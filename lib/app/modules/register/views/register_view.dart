import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:dietin/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        titleTextStyle: AppTextStyles.headingAppBar,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Text(
                      'Selamat datang, silakan isi data diri Anda',
                      style: AppTextStyles.bodyLight,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomTextField(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukan nama lengkap',
                    controller: controller.nameController,
                    keyboardType: TextInputType.name,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/images/user_icon.svg',
                        width: 24.w,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 28.h),
                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'Masukan email',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: AppColors.primary,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 28.h),
                  Obx(
                    () => CustomTextField(
                      labelText: 'Kata Sandi',
                      hintText: 'Buat kata sandi',
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: controller.passwordController,
                      obscureText: controller.isObscure.value,
                      prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isObscure.value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.toggle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Obx(
                    () => CustomTextField(
                      labelText: 'Konfirmasi Kata Sandi',
                      hintText: 'Konfirmasi kata sandi',
                      keyboardType: TextInputType.visiblePassword,
                      controller: controller.confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      obscureText: controller.isObscure.value,
                      prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isObscure.value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.toggle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Obx(()=> controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      :
                  CustomButton(
                    text: 'Buat Akun',
                    onPressed: () {
                      controller.register();
                    },
                    backgroundColor: AppColors.mainBlack,
                    borderRadius: 64,
                    textStyle: AppTextStyles.label.copyWith(
                      color: AppColors.light,
                      fontSize: 18.sp,
                    ),
                  )),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' Sudah mempunyai akun?',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.mainBlack,
                          fontSize: 12.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          ' Masuk',
                          style: AppTextStyles.labelBold.copyWith(
                            decoration: TextDecoration.underline,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
