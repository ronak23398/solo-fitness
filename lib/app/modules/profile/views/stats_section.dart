import 'package:flutter/material.dart';
import 'package:solo_fitness/app/data/models/user_model.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';

class StatsSection extends StatelessWidget {
  final UserModel user;

  const StatsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HUNTER STATS', style: AppTextStyles.subtitleBlack),
          const SizedBox(height: 16),
          _buildStatCard('Strength', user.strength, AppColors.strengthColor),
          _buildStatCard('Endurance', user.endurance, AppColors.enduranceColor),
          _buildStatCard('Agility', user.agility, AppColors.agilityColor),
          _buildStatCard('Intelligence', user.intelligence, AppColors.intelligenceColor),
          _buildStatCard('Discipline', user.discipline, AppColors.disciplineColor),
        ],
      ),
    );
  }

  Widget _buildStatCard(String statName, int value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(_getStatIcon(statName), color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(statName, style: AppTextStyles.statLabel),
            const Spacer(),
            Text(
              value.toString(),
              style: AppTextStyles.statValue.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatIcon(String statName) {
    switch (statName) {
      case 'Strength':
        return Icons.fitness_center;
      case 'Endurance':
        return Icons.directions_run;
      case 'Agility':
        return Icons.flash_on;
      case 'Intelligence':
        return Icons.psychology;
      case 'Discipline':
        return Icons.access_time;
      default:
        return Icons.star;
    }
  }
}