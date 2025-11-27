import 'package:dietin/app/shared/constants/constant.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/statistics_controller.dart';

class StatisticsView extends GetView<StatisticsController> {
  const StatisticsView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.loadStatistics(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 11.h),
                Center(
                  child: Text('Statistik', style: AppTextStyles.headingAppBar),
                ),
                SizedBox(height: 20.h),
                _buildTabBar(),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Asupan Nutrisi', style: AppTextStyles.label),
                      _buildNutrientDropdown(),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Content Area (Chart)
                // Menggunakan Obx agar rebuild saat tab/data berubah
                Obx(() {
                  if (controller.isLoading.value && controller.allLogs.isEmpty) {
                    return Container(
                      height: 300.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  switch (controller.selectedTab.value) {
                    case 0:
                      return _buildDailyChart();
                    case 1:
                      return _buildWeeklyChart();
                    case 2:
                      return _buildMonthlyChart();
                    default:
                      return SizedBox();
                  }
                }),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientDropdown() {
    return Obx(
          () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(64.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Theme(
          data: Theme.of(Get.context!).copyWith(
            popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12.r,
                ),
              ),
            ),
          ),
          child: DropdownButton<String>(
            value: controller.selectedNutrient.value,
            underline: SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
            dropdownColor: Colors.white,
            style: AppTextStyles.label.copyWith(fontSize: 14.sp),
            items: controller.nutrients.map((String nutrient) {
              return DropdownMenuItem<String>(
                value: nutrient,
                child: Text(nutrient),
              );
            }).toList(),
            onChanged: controller.changeNutrient,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Hari', 'Minggu', 'Bulan'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Obx(
              () => Row(
            children: List.generate(
              tabs.length,
                  (index) => Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: Container(
                    margin: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: controller.selectedTab.value == index
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: AppTextStyles.label.copyWith(
                          color: controller.selectedTab.value == index
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyChart() {
    return Obx(() {
      final data = controller.nutritionData[controller.selectedNutrient.value]!;
      final sections = data['sections'] as List;
      final total = data['total'];
      final consumed = data['consumed'];

      return Column(
        children: [
          SizedBox(height: 20.h),
          SizedBox(
            height: 250.h,
            child: Center(
              child: _buildCircularProgress(
                sections: sections,
                total: total,
                consumed: consumed,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Detail', style: AppTextStyles.labelBold),
                Text(
                  '${controller.selectedNutrient.value} (${controller.currentUnit})',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildMealCard('assets/images/sunrise_ic.svg', 'Sarapan', sections[0]['value']),
                SizedBox(height: 12.h),
                _buildMealCard('assets/images/sun_ic.svg', 'Makan Siang', sections[1]['value']),
                SizedBox(height: 12.h),
                _buildMealCard('assets/images/sunset_ic.svg', 'Makan Malam', sections[2]['value']),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget _buildMealCard(String iconPath, String label, int value) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset(iconPath, width: 24.w, height: 24.h),
              ),
              SizedBox(width: 12.w),
              Text(label, style: AppTextStyles.bodySmallSemiBold),
            ],
          ),
          Text(
            '$value',
            style: AppTextStyles.labelBold.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Obx(() {
      final data =
      controller.weeklyNutritionData[controller.selectedNutrient.value]!;
      final days = data['days'] as List;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Bar Chart
            Container(
              height: 200.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.mainWhite,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(days.length, (index) {
                  final day = days[index];
                  final percentage = day['percentage'] as double;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.toggleDaySelection(index),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Obx(() {
                                  final isSelected =
                                      controller.selectedDayIndex.value == index;
                                  return Container(
                                    width: double.infinity,
                                    height: 150.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.calorieBackgroundActive
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                      border: isSelected
                                          ? Border.all(
                                        color: AppColors.primary,
                                        width: 2.w,
                                      )
                                          : null,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        height: (150.h * percentage).clamp(
                                          10.0,
                                          150.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                          AppColors.calorieBackgroundActive,
                                          borderRadius: BorderRadius.circular(
                                            100.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Obx(() {
                              final isSelected =
                                  controller.selectedDayIndex.value == index;
                              return Text(
                                controller.weekDays[index],
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 12.sp,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.lightGrey,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 30.h),
            // Detail Section
            Obx(() {
              final selectedIndex = controller.selectedDayIndex.value;

              if (selectedIndex >= 0 && selectedIndex < days.length) {
                final selectedDay = days[selectedIndex];
                final breakdown = selectedDay['breakdown'] as List;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detail ${selectedDay['day']}',
                          style: AppTextStyles.labelBold,
                        ),
                        Text(
                          '${controller.selectedNutrient.value} (${controller.currentUnit})',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildMealCard('assets/images/sunrise_ic.svg', breakdown[0]['label'], breakdown[0]['value']),
                    SizedBox(height: 12.h),
                    _buildMealCard('assets/images/sun_ic.svg', breakdown[1]['label'], breakdown[1]['value']),
                    SizedBox(height: 12.h),
                    _buildMealCard('assets/images/sunset_ic.svg', breakdown[2]['label'], breakdown[2]['value']),
                  ],
                );
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Detail', style: AppTextStyles.labelBold),
                      Text(
                        '${controller.selectedNutrient.value} (${controller.currentUnit})',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ...List.generate(days.length, (index) {
                    final day = days[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: GestureDetector(
                        onTap: () => controller.toggleDaySelection(index),
                        child: Container(
                          width: 1.sw,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.mainWhite,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4.r,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.calorieBackgroundActive
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        controller.weekDays[index],
                                        style: AppTextStyles.bodySmallSemiBold
                                            .copyWith(
                                          color: AppColors.primary,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    day['day'],
                                    style: AppTextStyles.bodySmallSemiBold,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${day['value']}',
                                    style: AppTextStyles.labelBold.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.lightGrey,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildMonthlyChart() {
    return Obx(() {
      final filteredData = controller.filteredMonthlyData;
      final days = filteredData['days'] as List;
      final total = filteredData['total'];
      final startDay = filteredData['startDay'];
      final endDay = filteredData['endDay'];

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),
            // Filter Bulan dan Tahun
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(64.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Theme(
                      data: Theme.of(Get.context!).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: controller.selectedMonth.value,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        style: AppTextStyles.label.copyWith(fontSize: 14.sp),
                        items: controller.months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: controller.changeMonth,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(64.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Theme(
                    data: Theme.of(Get.context!).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: controller.selectedYear.value,
                      underline: SizedBox(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                      dropdownColor: Colors.white,
                      style: AppTextStyles.label.copyWith(fontSize: 14.sp),
                      items: controller.years.map((String year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: controller.changeYear,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Navigasi Rentang Tanggal
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: controller.currentDateRangeIndex.value > 0
                        ? controller.previousDateRange
                        : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: controller.currentDateRangeIndex.value > 0
                          ? AppColors.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                  Text(
                    'Tanggal $startDay - $endDay',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed:
                    controller.currentDateRangeIndex.value <
                        controller.totalDateRanges - 1
                        ? controller.nextDateRange
                        : null,
                    icon: Icon(
                      Icons.chevron_right,
                      color:
                      controller.currentDateRangeIndex.value <
                          controller.totalDateRanges - 1
                          ? AppColors.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Line Chart
            Container(
              width: double.infinity,
              height: 250.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.mainWhite,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: LineChartPainter(
                  days: days,
                  total: total,
                  color: AppColors.calorieBackgroundActive,
                ),
                child: Container(),
              ),
            ),
            SizedBox(height: 20.h),
            // Summary
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.mainWhite,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  // Calculate statistics
                  final values = days
                      .map((day) => day['value'] as int)
                      .toList();

                  if (values.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ringkasan', style: AppTextStyles.labelBold),
                        SizedBox(height: 12.h),
                        Text(
                          'Tidak ada data',
                          style: AppTextStyles.label.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }

                  final average =
                  (values.fold<int>(0, (sum, val) => sum + val) /
                      values.length)
                      .round();
                  final highest = values.reduce((a, b) => a > b ? a : b);
                  final lowest = values.reduce((a, b) => a < b ? a : b);
                  final totalMonth = values.fold<int>(
                    0,
                        (sum, val) => sum + val,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ringkasan', style: AppTextStyles.labelBold),
                      SizedBox(height: 12.h),
                      _buildSummaryRow('Rata-rata Harian', '$average'),
                      SizedBox(height: 8.h),
                      _buildSummaryRow('Tertinggi', '$highest'),
                      SizedBox(height: 8.h),
                      _buildSummaryRow('Terendah', '$lowest'),
                      SizedBox(height: 8.h),
                      _buildSummaryRow('Total Bulan', '$totalMonth'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: AppTextStyles.label)),
        Text(
          '$value ${controller.currentUnit}',
          style: AppTextStyles.labelBold.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildCircularProgress({
    required List sections,
    required int total,
    required int consumed,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250.w,
          height: 250.h,
          child: CustomPaint(
            painter: CircularProgressPainter(sections: sections, total: total),
          ),
        ),
        // Center text
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$consumed',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              '/ $total',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 4.h),
            Text(
              controller.selectedNutrient.value,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final List sections;
  final int total;

  CircularProgressPainter({required this.sections, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = 40.0;

    final bgPaint = Paint()
      ..color = AppColors.calorieBackgroundActive.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    double totalConsumed = 0;
    for (var section in sections) {
      totalConsumed += section['value'];
    }

    if (totalConsumed > 0) {
      final sweepAngle = (totalConsumed / total) * 2 * math.pi;

      final paint = Paint()
        ..color = AppColors.calorieBackgroundActive
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -math.pi / 2,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LineChartPainter extends CustomPainter {
  final List days;
  final int total;
  final Color color;

  LineChartPainter({
    required this.days,
    required this.total,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPadding = 35.0;
    final bottomPadding = 5.0;
    final topPadding = 10.0;
    final rightPadding = 10.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 4; i++) {
      double y = topPadding + (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        gridPaint,
      );

      if (total > 0) {
        final yValue = (total * (4 - i) / 4).round();
        final yLabelPainter = TextPainter(
          text: TextSpan(
            text: '$yValue',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        yLabelPainter.layout();
        yLabelPainter.paint(
          canvas,
          Offset(
            leftPadding - yLabelPainter.width - 5,
            y - yLabelPainter.height / 2,
          ),
        );
      }
    }

    if (days.isEmpty || total == 0) return;

    final path = Path();
    final fillPath = Path();
    final pointRadius = 4.0;

    final points = <Offset>[];
    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final value = day['value'] as int;
      final percentage = (value / total).clamp(0.0, 1.0);

      final x =
          leftPadding +
              (days.length > 1
                  ? (chartWidth / (days.length - 1)) * i
                  : chartWidth / 2);
      final y = topPadding + chartHeight - (chartHeight * percentage);

      points.add(Offset(x, y));
    }

    if (points.length == 1) {
      final pointPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final pointBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(points[0], pointRadius + 2, pointBorderPaint);
      canvas.drawCircle(points[0], pointRadius, pointPaint);

      return;
    }

    fillPath.moveTo(points[0].dx, topPadding + chartHeight);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];

      final controlPoint1 = Offset(prev.dx + (curr.dx - prev.dx) / 2, prev.dy);
      final controlPoint2 = Offset(prev.dx + (curr.dx - prev.dx) / 2, curr.dy);

      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        curr.dx,
        curr.dy,
      );
    }

    fillPath.lineTo(points.last.dx, topPadding + chartHeight);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];

      final controlPoint1 = Offset(prev.dx + (curr.dx - prev.dx) / 2, prev.dy);
      final controlPoint2 = Offset(prev.dx + (curr.dx - prev.dx) / 2, curr.dy);

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        curr.dx,
        curr.dy,
      );
    }

    canvas.drawPath(path, paint);

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, pointRadius + 2, pointBorderPaint);
      canvas.drawCircle(point, pointRadius, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}