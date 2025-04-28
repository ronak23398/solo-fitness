import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/modules/profile/views/achievement_section.dart';
import 'package:solo_fitness/app/modules/profile/views/black_heart_status.dart';
import 'package:solo_fitness/app/modules/profile/views/profile_header.dart';
import 'package:solo_fitness/app/modules/profile/views/stats_section.dart';
import 'package:solo_fitness/app/modules/profile/views/stats_web_chart.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('HUNTER PROFILE', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textLight),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          color: AppColors.primaryBlue,
          backgroundColor: AppColors.cardBackground,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Profile Header with Avatar and Stats
                ProfileHeader(
                  user: controller.user.value,
                  currentClass: controller.getCurrentClass(),
                ),
                AdaptiveStatsWebChart(
                  user: controller.user.value!,
                  size: 280.0,
                ),
                // Stats Section
                StatsSection(user: controller.user.value),

                // Streaks Section
                AchievementsSection(user: controller.user.value),

                // Black Heart Status
                if (controller.user.value.isDead)
                  BlackHeartStatus(
                    user: controller.user.value,
                    onUseBlackHeart: () => Get.toNamed('/revive'),
                    onNoBlackHearts: () => Get.toNamed('/shop'),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }
}
