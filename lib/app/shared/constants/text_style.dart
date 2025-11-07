import 'package:dietin/app/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle get label => GoogleFonts.plusJakartaSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.mainBlack,
  );
  static TextStyle get labelBold => GoogleFonts.plusJakartaSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.mainBlack,
  );
  static TextStyle get headingAppBar => GoogleFonts.plusJakartaSans(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.mainBlack,
  );
  static TextStyle get bodyLight => GoogleFonts.plusJakartaSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGrey,
  );
  static TextStyle get inputText => GoogleFonts.plusJakartaSans(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );
  static TextStyle get onboardBigTitle => GoogleFonts.plusJakartaSans(
    fontSize: 31.83.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.mainBlack,
  );
  static TextStyle get onboardBigSubtitle => GoogleFonts.plusJakartaSans(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.mainBlack,
  );
  static TextStyle get botnavInactive => GoogleFonts.plusJakartaSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
  );
  static TextStyle get botnavActive => GoogleFonts.plusJakartaSans(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}
