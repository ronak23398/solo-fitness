// penalty_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/models/task_model.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/data/widgets/custom_button.dart';
import 'package:solo_fitness/app/modules/penalty/controller/penalty_controller.dart';

class PenaltyView extends GetView<PenaltyController> {
  const PenaltyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text(
          'PENALTY MISSIONS',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.neonPurple,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.dangerRed,
            ),
          );
        }

        return Column(
          children: [
            // Warning banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppColors.warningButton,
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.deathRed,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'PENALTY MODE ACTIVE',
                    style: AppTextStyles.warningTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete all penalty missions before midnight or your account will be terminated.',
                    style: AppTextStyles.warningText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.dangerDarkRed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timer,
                    color: AppColors.dangerRed,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Time remaining: ${_getRemainingTime()}',
                    style: AppTextStyles.warningText,
                  ),
                ],
              ),
            ),
            
            // Penalty Tasks List
            Expanded(
              child: controller.penaltyTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.successGreen,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'All penalty missions completed',
                            style: AppTextStyles.bodyText,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'RETURN TO HOME',
                            onPressed: () => Get.offAllNamed('/home'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: controller.penaltyTasks.length,
                      itemBuilder: (context, index) {
                        final task = controller.penaltyTasks[index];
                        return _buildPenaltyTaskCard(task, index);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
  
  Widget _buildPenaltyTaskCard(TaskModel task, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isCompleted ? AppColors.successGreen : AppColors.dangerRed,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (task.isCompleted ? AppColors.successGreen : AppColors.dangerRed).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.deathScreen,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  task.category as String,
                  style: AppTextStyles.deathScreen,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.extremeDifficulty.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'EXTREME',
                    style: TextStyle(
                      color: AppColors.extremeDifficulty,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              task.title,
              style: AppTextStyles.deathMessage.copyWith(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description,
                style: AppTextStyles.taskTitle.copyWith(
                  color: task.isCompleted ? AppColors.dangerDarkRed : AppColors.darkGrey,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _buildRewardChip(
                  '${task.statPoints} ${task.category} POINTS',
                  AppColors.statPointsBg,
                  AppColors.statPointsText,
                ),
                const SizedBox(width: 8),
                _buildRewardChip(
                  '${task.xpPoints} XP',
                  AppColors.xpPointsBg,
                  AppColors.xpPointsText,
                ),
                const Spacer(),
                if (task.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.successGreen,
                    size: 28,
                  )
                else
                  ElevatedButton(
                    onPressed: () => controller.markPenaltyTaskCompleted(task.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dangerRed,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'COMPLETE',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRewardChip(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  String _getRemainingTime() {
    // Calculate remaining time until midnight
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final difference = midnight.difference(now);
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    return '$hours hrs $minutes mins';
  }
}