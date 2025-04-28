// components/deadline_section.dart
import 'package:flutter/material.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';

class DeadlineSection extends StatelessWidget {
  final String timeRemaining;
  
  const DeadlineSection({
    Key? key, 
    required this.timeRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.neonBlue, width: 1),
            ),
            child: const Icon(
              Icons.timer,
              color: AppColors.neonBlue,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deadline',
                style: AppTextStyles.smallBodyGrey,
              ),
              Text(
                'Quests reset in: $timeRemaining',
                style: AppTextStyles.timerText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}