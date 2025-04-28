// components/streak_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';

class StreakSection extends StatelessWidget {
  final int currentStreak;
  final bool hasStreakReward;
  
  const StreakSection({
    Key? key, 
    required this.currentStreak,
    required this.hasStreakReward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.goldAccent.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.goldAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STREAK',
                style: AppTextStyles.smallBodyGrey,
              ),
              Text(
                '$currentStreak day${currentStreak > 1 ? 's' : ''} streak',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.goldAccent,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: AppColors.goldAccent.withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasStreakReward) ...[
            const Spacer(),
            TextButton.icon(
              onPressed: () => Get.toNamed('/streak'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                backgroundColor: AppColors.goldAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(
                Icons.redeem,
                color: Colors.black,
                size: 16,
              ),
              label: Text(
                'CLAIM REWARD',
                style: AppTextStyles.buttonText.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}