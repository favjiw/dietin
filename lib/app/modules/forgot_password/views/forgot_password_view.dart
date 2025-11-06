import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:dietin/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        title: const Text('Lupa Kata Sandi'),
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
                      'Silakan isi email anda untuk mengganti kata sandi',
                      style: AppTextStyles.bodyLight,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                    child: CustomTextField(
                      labelText: 'Email',
                      hintText: 'Masukan email',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        color: AppColors.primary,
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  SizedBox(height: 36.h),
                  CustomButton(
                    text: 'Kirim Email',
                    onPressed: () {},
                    backgroundColor: AppColors.mainBlack,
                    borderRadius: 64,
                    textStyle: AppTextStyles.label.copyWith(
                      color: AppColors.light,
                      fontSize: 18.sp,
                    ),
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
