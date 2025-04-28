// components/quests_header.dart
import 'package:flutter/material.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';

class QuestsHeader extends StatelessWidget {
  final int completedTasksCount;
  final int totalTasksCount;
  
  const QuestsHeader({
    Key? key, 
    required this.completedTasksCount,
    required this.totalTasksCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.neonBlue,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'TODAY\'S QUESTS',
            style: AppTextStyles.subtitleWhite.copyWith(
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.darkBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.neonBlue.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Text(
              '$completedTasksCount/$totalTasksCount',
              style: AppTextStyles.smallBodyWhite,
            ),
          ),
        ],
      ),
    );
  }
}