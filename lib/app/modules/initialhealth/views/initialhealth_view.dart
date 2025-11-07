import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/initialhealth_controller.dart';

class InitialhealthView extends GetView<InitialhealthController> {
  const InitialhealthView({super.key});

  static const int totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.mainWhite,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Obx(() {
            final idx = controller.pageIndex.value;

            String title = 'Informasi Pengguna';
            if (idx == 1) title = 'Kondisi Tubuh';
            if (idx == 2) title = 'Preferensi Alergi';

            return AppBar(
              backgroundColor: AppColors.mainWhite,
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: idx == 0
                  ? null
                  : IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.mainBlack,
                      ),
                      onPressed: () {
                        controller.pageController.previousPage(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.ease,
                        );
                      },
                    ),
              title: Text(title, style: AppTextStyles.headingAppBar),
            );
          }),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height - kToolbarHeight - 40.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PageView(
                      pageSnapping: true,
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller.pageController,
                      onPageChanged: controller.updatePageIndex,
                      children: [
                        // PAGE 0
                        Form(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 52.h),
                                // GANTI seluruh Obx(() { final controller = Get.find<InitialhealthController>(); ... })
                                Obx(() {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jenis Kelamin *',
                                        style: AppTextStyles.labelBold.copyWith(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                controller.selectGender('male'),
                                            child: Container(
                                              width: 166.w,
                                              height: 65.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                border: Border.all(
                                                  width:
                                                      controller
                                                              .selectedGender
                                                              .value ==
                                                          'male'
                                                      ? 2.w
                                                      : 1.w,
                                                  color:
                                                      controller
                                                              .selectedGender
                                                              .value ==
                                                          'male'
                                                      ? AppColors.primary
                                                      : AppColors.lightGrey,
                                                ),
                                                color:
                                                    controller
                                                            .selectedGender
                                                            .value ==
                                                        'male'
                                                    ? AppColors.primary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          )
                                                    : Colors.transparent,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20.r,
                                                      backgroundColor:
                                                          controller
                                                                  .selectedGender
                                                                  .value ==
                                                              'male'
                                                          ? AppColors.primary
                                                          : AppColors.mainWhite,
                                                      child: Image.asset(
                                                        'assets/images/male_ic.png',
                                                      ),
                                                    ),
                                                    SizedBox(width: 22.w),
                                                    Text(
                                                      'Pria',
                                                      style: AppTextStyles
                                                          .labelBold
                                                          .copyWith(
                                                            color:
                                                                controller
                                                                        .selectedGender
                                                                        .value ==
                                                                    'male'
                                                                ? AppColors
                                                                      .primary
                                                                : Colors
                                                                      .black87,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => controller
                                                .selectGender('female'),
                                            child: Container(
                                              width: 166.w,
                                              height: 65.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                border: Border.all(
                                                  width:
                                                      controller
                                                              .selectedGender
                                                              .value ==
                                                          'female'
                                                      ? 2.w
                                                      : 1.w,
                                                  color:
                                                      controller
                                                              .selectedGender
                                                              .value ==
                                                          'female'
                                                      ? AppColors.primary
                                                      : AppColors.lightGrey,
                                                ),
                                                color:
                                                    controller
                                                            .selectedGender
                                                            .value ==
                                                        'female'
                                                    ? AppColors.primary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          )
                                                    : Colors.transparent,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20.r,
                                                      backgroundColor:
                                                          controller
                                                                  .selectedGender
                                                                  .value ==
                                                              'female'
                                                          ? AppColors.primary
                                                          : AppColors.mainWhite,
                                                      child: Image.asset(
                                                        'assets/images/female_ic.png',
                                                      ),
                                                    ),
                                                    SizedBox(width: 22.w),
                                                    Text(
                                                      'Wanita',
                                                      style: AppTextStyles
                                                          .labelBold
                                                          .copyWith(
                                                            color:
                                                                controller
                                                                        .selectedGender
                                                                        .value ==
                                                                    'female'
                                                                ? AppColors
                                                                      .primary
                                                                : Colors
                                                                      .black87,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (controller.pageIndex.value == 0 &&
                                          !controller.isGenderSelected.value)
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.h),
                                          child: Text(
                                            'Jenis kelamin harus dipilih',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                                SizedBox(height: 25.h),
                                Obx(() {
                                  final valid =
                                      controller.isBirthDateValid.value;
                                  final showErr =
                                      controller
                                          .birthDateController
                                          .text
                                          .isNotEmpty &&
                                      !valid;

                                  return CustomTextField(
                                    labelText: 'Tanggal Lahir *',
                                    hintText: 'DD/MM/YYYY',
                                    keyboardType: TextInputType.none,
                                    controller: controller.birthDateController,
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      await controller.pickBirthDate(context);
                                    },
                                    suffixIcon: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: AppColors.primary,
                                    ),
                                    errorText: showErr
                                        ? 'Tanggal lahir tidak valid'
                                        : null,
                                  );
                                }),
                                SizedBox(height: 25.h),
                                Obx(() {
                                  final valid = controller.isHeightValid.value;
                                  final showErr =
                                      controller
                                          .heightController
                                          .text
                                          .isNotEmpty &&
                                      !valid;

                                  return CustomTextField(
                                    labelText: 'Tinggi Badan *',
                                    hintText: 'Contoh: 170',
                                    keyboardType: TextInputType.number,
                                    controller: controller.heightController,
                                    suffixIcon: Image.asset(
                                      'assets/images/cm_ic.png',
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                    errorText: showErr
                                        ? 'Tinggi badan harus antara 50–250 cm'
                                        : null,
                                  );
                                }),
                                SizedBox(height: 25.h),
                                Obx(() {
                                  final valid = controller.isWeightValid.value;
                                  final showErr =
                                      controller
                                          .weightController
                                          .text
                                          .isNotEmpty &&
                                      !valid;

                                  return CustomTextField(
                                    labelText: 'Berat Badan *',
                                    hintText: 'Contoh: 65',
                                    keyboardType: TextInputType.number,
                                    controller: controller.weightController,
                                    suffixIcon: Image.asset(
                                      'assets/images/cm_ic.png',
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                    errorText: showErr
                                        ? 'Berat badan harus antara 2–300 kg'
                                        : null,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        // PAGE 1
                        Form(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 25.h),
                                Obx(() {
                                  final sel = controller.selectedGoal.value;
                                  final showErr = sel.isEmpty;

                                  return CustomTextField(
                                    labelText: 'Tujuan Utama',
                                    hintText: 'Pilih tujuan kamu',
                                    keyboardType: TextInputType.none,
                                    controller: controller.goalController,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.primary,
                                    ),
                                    errorText: showErr
                                        ? 'Tujuan utama wajib dipilih'
                                        : null,
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      final picked =
                                          await showModalBottomSheet<String>(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                            ),
                                            builder: (_) {
                                              return SafeArea(
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: controller.goals.map((
                                                    g,
                                                  ) {
                                                    return Obx(
                                                      () => ListTile(
                                                        title: Text(g),
                                                        trailing:
                                                            controller
                                                                    .selectedGoal
                                                                    .value ==
                                                                g
                                                            ? const Icon(
                                                                Icons
                                                                    .check_rounded,
                                                              )
                                                            : null,
                                                        onTap: () =>
                                                            Get.back(result: g),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              );
                                            },
                                          );
                                      if (picked != null) {
                                        controller.setGoal(picked);
                                      }
                                    },
                                  );
                                }),
                                SizedBox(height: 25.h),
                                Obx(() {
                                  final valid = controller.isHeightValid.value;
                                  final showErr =
                                      controller
                                          .heightController
                                          .text
                                          .isNotEmpty &&
                                      !valid;

                                  return CustomTextField(
                                    labelText: 'Target Berat Badan',
                                    hintText: 'Masukkan target kamu',
                                    keyboardType: TextInputType.number,
                                    controller:
                                        controller.targetWeightController,
                                    suffixIcon: Image.asset(
                                      'assets/images/cm_ic.png',
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                    errorText: showErr
                                        ? 'Berat badan harus antara 2–300 kg'
                                        : null,
                                  );
                                }),
                                SizedBox(height: 25.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tingkat Aktivitas',
                                      style: AppTextStyles.label,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        await showModalBottomSheet<String>(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          builder: (_) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.9,
                                              child: SafeArea(
                                                child: Padding(
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          width: 40.w,
                                                          height: 5.h,
                                                          decoration: BoxDecoration(
                                                            color: AppColors
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12.r,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 40.h),
                                                      Text(
                                                        'Sedentary (Banyak duduk)',
                                                        style: AppTextStyles
                                                            .labelBold,
                                                      ),
                                                      SizedBox(height: 20.h),
                                                      Text(
                                                        'Hampir tidak berolahraga dan lebih banyak duduk sepanjang hari, misalnya bekerja di depan komputer, sedikit berjalan kaki.',
                                                        style: AppTextStyles
                                                            .bodyLight,
                                                      ),
                                                      SizedBox(height: 24.h),
                                                      Text(
                                                        'Ringan (1–2x olahraga/minggu)',
                                                        style: AppTextStyles
                                                            .labelBold,
                                                      ),
                                                      SizedBox(height: 20.h),
                                                      Text(
                                                        'Hampir tidak berolahraga dan lebih banyak duduk sepanjang hari, misalnya bekerja di depan komputer, sedikit berjalan kaki.',
                                                        style: AppTextStyles
                                                            .bodyLight,
                                                      ),
                                                      SizedBox(height: 24.h),
                                                      Text(
                                                        'Sedang (3–5x olahraga/minggu)',
                                                        style: AppTextStyles
                                                            .labelBold,
                                                      ),
                                                      SizedBox(height: 20.h),
                                                      Text(
                                                        'Rutin berolahraga beberapa kali seminggu, aktivitas harian cukup aktif seperti berjalan banyak atau naik turun tangga.',
                                                        style: AppTextStyles
                                                            .bodyLight,
                                                      ),
                                                      SizedBox(height: 24.h),
                                                      Text(
                                                        'Berat (6–7x olahraga/minggu)',
                                                        style: AppTextStyles
                                                            .labelBold,
                                                      ),
                                                      SizedBox(height: 20.h),
                                                      Text(
                                                        'Berolahraga intens hampir setiap hari atau memiliki pekerjaan fisik berat, dengan waktu latihan cukup lama.',
                                                        style: AppTextStyles
                                                            .bodyLight,
                                                      ),
                                                      SizedBox(height: 24.h),
                                                      Text(
                                                        'Atlet (Latihan profesional)',
                                                        style: AppTextStyles
                                                            .labelBold,
                                                      ),
                                                      SizedBox(height: 20.h),
                                                      Text(
                                                        'Berlatih secara intens setiap hari, mengikuti program kebugaran atau olahraga kompetitif dengan tingkat aktivitas sangat tinggi.',
                                                        style: AppTextStyles
                                                            .bodyLight,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/images/info_ic.png',
                                        width: 25.w,
                                        height: 25.h,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22.h),
                                Obx(() {
                                  final sel =
                                      controller.selectedActivityLevel.value;

                                  Widget tile(
                                    String value,
                                    String label,
                                    String asset,
                                  ) {
                                    final active = sel == value;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.selectActivity(value),
                                        child: Container(
                                          height: 65.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            border: Border.all(
                                              width: active ? 2.w : 1.w,
                                              color: active
                                                  ? AppColors.primary
                                                  : AppColors.lightGrey,
                                            ),
                                            color: active
                                                ? AppColors.primary.withValues(alpha:
                                                    0.1,
                                                  )
                                                : Colors.transparent,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 15.r,
                                                  backgroundColor: active
                                                      ? AppColors.primary
                                                      : AppColors.mainWhite,
                                                  child: Image.asset(asset),
                                                ),
                                                SizedBox(width: 3.w),
                                                Text(
                                                  label,
                                                  style: AppTextStyles.labelBold
                                                      .copyWith(
                                                        color: active
                                                            ? AppColors.primary
                                                            : Colors.black87,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          tile(
                                            'sedentari',
                                            'Sedentari',
                                            'assets/images/male_ic.png',
                                          ),
                                          SizedBox(width: 8.w),
                                          tile(
                                            'ringan',
                                            'Ringan',
                                            'assets/images/male_ic.png',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 9.h),
                                      Row(
                                        children: [
                                          tile(
                                            'sedang',
                                            'Sedang',
                                            'assets/images/male_ic.png',
                                          ),
                                          SizedBox(width: 9.w),
                                          tile(
                                            'berat',
                                            'Berat',
                                            'assets/images/male_ic.png',
                                          ),
                                          SizedBox(width: 9.w),
                                          tile(
                                            'atlet',
                                            'Atlet',
                                            'assets/images/male_ic.png',
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        // PAGE 2
                        Form(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 25.h),
                                  Text('Alergi', style: AppTextStyles.labelBold),
                                  SizedBox(height: 12.h),
                                  Obx(() {
                                    final sel = controller.selectedAllergies;
                                    return Container(
                                      width: 1.sw,
                                      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.r),
                                        color: AppColors.light,
                                      ),
                                      child: sel.isEmpty
                                          ? Text('Belum ada pilihan', style: AppTextStyles.bodyLight)
                                          : Wrap(
                                        spacing: 8.w,
                                        runSpacing: 8.h,
                                        children: controller.allergyCategories
                                            .where((c) => sel.contains(c.id))
                                            .map((c) => Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(6.54.r),
                                          ),
                                          child: Text(c.label,
                                              style: AppTextStyles.bodyLight.copyWith(color: AppColors.mainWhite)),
                                        ))
                                            .toList(),
                                      ),
                                    );
                                  }),
                            
                                  SizedBox(height: 25.h),
                                  
                                  Obx(() {
                                    final sel = controller.selectedAllergies;
                            
                                    Widget tile(AllergyCategory c) {
                                      final active = sel.contains(c.id);
                                      return GestureDetector(
                                        onTap: () => controller.toggleAllergy(c.id),
                                        child: Container(
                                          height: 65.h,
                                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.r),
                                            border: Border.all(
                                              width: active ? 2.w : 1.w,
                                              color: active ? AppColors.primary : AppColors.lightGrey,
                                            ),
                                            color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 15.r,
                                                backgroundColor: active ? AppColors.primary : AppColors.mainWhite,
                                                child: Image.asset(c.asset),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  c.label,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppTextStyles.labelBold.copyWith(
                                                    color: active ? AppColors.primary : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                            
                                    // dua kolom responsif
                                    final itemWidth = (1.sw - 16.w * 2 - 9.w) / 2;
                                    return Wrap(
                                      spacing: 9.w,
                                      runSpacing: 9.h,
                                      children: controller.allergyCategories
                                          .map((c) => SizedBox(width: itemWidth, child: tile(c)))
                                          .toList(),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // FOOTER: indikator + tombol
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.h),
                    child: SizedBox(
                      height: 130.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            final idx = controller.pageIndex.value;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(totalPages, (i) {
                                final active = idx >= i;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  width: 90.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? AppColors.primary
                                        : AppColors.onboardInactive,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                );
                              }),
                            );
                          }),
                          SizedBox(height: 40.h),

                          // tombol next/selesai
                          Obx(() {
                            final isLast =
                                controller.pageIndex.value == totalPages - 1;
                            return Center(
                              child: CustomButton(
                                text: isLast ? 'Selesai' : 'Selanjutnya',
                                onPressed: () {
                                  if (isLast) {
                                    controller.completeOnboarding();
                                  } else {
                                    controller.nextPage();
                                  }
                                },
                                backgroundColor: AppColors.mainBlack,
                                borderRadius: 64,
                                textStyle: AppTextStyles.label.copyWith(
                                  color: AppColors.light,
                                  fontSize: 18.sp,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
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
