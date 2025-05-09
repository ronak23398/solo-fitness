// home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/services/firebasetasksupload.dart';
import 'package:solo_fitness/app/modules/home/views/components/avatar_section.dart';
import 'package:solo_fitness/app/modules/home/views/components/custom_appbar.dart';
import 'package:solo_fitness/app/modules/home/views/components/quest_header.dart';
import 'package:solo_fitness/app/modules/home/views/components/task_list.dart';
import '../../../data/theme/colors.dart';
import '../../../data/theme/text_styles.dart';
import '../controller/home_controller.dart';
import 'components/xp_section.dart';
import 'components/deadline_section.dart';
import 'components/streak_section.dart';
import 'components/penalty_warning.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const CustomAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingIndicator();
        }
        
        if (controller.hasPenaltyMissions.value) {
          return PenaltyWarning();
        }
        
        if (controller.userDied.value) {
          // Redirect to death screen
          Future.microtask(() => Get.offAllNamed('/death'));
          return const SizedBox.shrink();
        }
        
        return RefreshIndicator(
          onRefresh: controller.refreshTasks,
          color: AppColors.neonBlue,
          backgroundColor: AppColors.cardBackground,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Player Avatar with glowing aura
                    const PlayerAvatarSection(),
                   
                    // XP Bar and Level info
                    XpSection(
                      currentXp: controller.currentXp.value,
                      requiredXp: controller.requiredXp.value,
                      userLevel: controller.userLevel.value,
                    ),
                    // ElevatedButton(onPressed: (){uploadToFirebaseRealtimeDB();}, child: Text("upload ")),
                    // Daily deadline
                    DeadlineSection(
                      timeRemaining: controller.formattedTimeRemaining.value,
                    ),
                    
                    // Streak info
                    if (controller.currentStreak.value > 0)
                      StreakSection(
                        currentStreak: controller.currentStreak.value,
                        hasStreakReward: controller.hasStreakReward.value,
                      ),
                      
                    // Section title for quests
                    QuestsHeader(
                      completedTasksCount: controller.completedTasksCount,
                      totalTasksCount: controller.totalTasksCount,
                    ),
                  ],
                ),
              ),
              
              // Task List
              TasksList(
                tasks: controller.tasks,
                onTaskCompleted: (taskId) => controller.markTaskCompleted(taskId),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.goToStore(),
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.shopping_bag, color: Colors.white),
        label: Text(
          'STORE',
          style: AppTextStyles.buttonTextSmall,
        ),
        elevation: 8,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: AppColors.neonBlue,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading quests...',
            style: AppTextStyles.subtitleNeonBlue,
          ),
        ],
      ),
    );
  }
}