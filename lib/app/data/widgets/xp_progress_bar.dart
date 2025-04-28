import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class XpProgressBar extends StatelessWidget {
  final int currentXp;
  final int requiredXp;
  final int level;

  const XpProgressBar({
    Key? key,
    required this.currentXp,
    required this.requiredXp,
    required this.level,
  }) : super(key: key);

  double get progress => currentXp / requiredXp;

  @override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Level $level',
            style: AppTextStyles.subtitleNeonBlue,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$currentXp/$requiredXp XP',
                style: AppTextStyles.xpCounter,
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 8),
      Stack(
        children: [
          // Background
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.darkGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Progress
          LayoutBuilder(
            builder: (context, constraints) {
              final progressWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
              return Container(
                height: 12,
                width: progressWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.neonBlue, AppColors.purpleAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonBlue.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                // Add the shine effect as a child of the progress container
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}}