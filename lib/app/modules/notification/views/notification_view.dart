import 'package:dietin/app/data/NotificationModel.dart';
import 'package:dietin/app/shared/constants/constant.dart';
import 'package:dietin/app/shared/widgets/notification_card.dart';
import 'package:dietin/app/shared/widgets/notification_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/notification_controller.dart';
class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.mainBlack,
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Notifikasi',
          style: AppTextStyles.headingAppBar.copyWith(fontSize: 20.sp),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.groups.isEmpty) {
          return const NotificationEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.groups.length,
          itemBuilder: (context, index) {
            final group = controller.groups[index];
            return _NotificationSection(group: group);
          },
        );
      }),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  final NotificationGroup group;

  const _NotificationSection({required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.header,
            style: AppTextStyles.bodySmallSemiBold.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: 8.h),
          Column(
            children: [
              for (final item in group.items) ...[
                NotificationCard(item: item),
                SizedBox(height: 10.h),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
