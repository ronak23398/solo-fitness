import 'package:flutter/material.dart';
import 'package:solo_fitness/app/data/models/user_model.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';

class AchievementsSection extends StatelessWidget {
  final UserModel user;

  const AchievementsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STREAKS & ACHIEVEMENTS',
            style: AppTextStyles.subtitleBlack,
          ),
          const SizedBox(height: 16),
          Card(
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAchievementRow(
                    'Current Streak',
                    '${user.currentStreak} days',
                    Icons.local_fire_department,
                    AppColors.infoBlue,
                  ),
                 
                  Divider(color: AppColors.classD),
                  _buildAchievementRow(
                    'Tasks Completed',
                    '${user.tasksCompleted} tasks',
                    Icons.check_circle,
                    AppColors.successGreen,
                  ),
                  if (user.titles.isNotEmpty) ...[
                    Divider(color: AppColors.disciplineColor),
                    _buildAchievementRow(
                      'Titles',
                      user.titles.join(', '),
                      Icons.military_tech,
                      Colors.orangeAccent,
                    ),
                  ],
                  if (user.blackHearts > 0) ...[
                    const Divider(color: AppColors.disciplineColor),
                    _buildAchievementRow(
                      'Black Hearts',
                      '${user.blackHearts}',
                      Icons.favorite,
                      Colors.purple,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementRow(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: AppTextStyles.xpCounter),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value, 
              style: AppTextStyles.statLabel,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}