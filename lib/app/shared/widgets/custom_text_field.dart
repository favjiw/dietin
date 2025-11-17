import 'package:dietin/app/shared/constants/colors.dart';
import 'package:dietin/app/shared/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool obscureText;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? labelText;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;

  final String? Function(String?)? validator;
  final String? errorText;

  final TextStyle? hintStyle;
  final TextStyle? inputStyle;
  final TextInputType? keyboardType;
  final int? maxLine;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.onTap,
    this.labelText,
    this.obscureText = false,
    this.width,
    this.height,
    this.fontSize,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.errorText,
    this.hintStyle,
    this.inputStyle,
    this.keyboardType,
    this.textInputAction,
    this.maxLine = 1,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText ?? '', style: AppTextStyles.label),
        SizedBox(height: 8.h),
        SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: TextFormField(
            cursorColor: AppColors.primary,
            onChanged: onChanged,
            maxLines: maxLine,
            keyboardType: keyboardType,
            controller: controller,
            textInputAction: textInputAction,
            obscureText: obscureText,
            validator: validator,
            style: inputStyle ?? AppTextStyles.inputText,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  hintStyle ??
                  AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: fontSize != null ? fontSize! - 2.sp : 14.sp,
                    color: Colors.grey,
                  ),
              errorText: errorText,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              filled: true,
              // fillcolor if null then use light
              fillColor: fillColor ?? AppColors.light,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
