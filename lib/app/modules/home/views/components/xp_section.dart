// components/xp_section.dart
import 'package:flutter/material.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';
import '../../../../data/widgets/xp_progress_bar.dart';

class XpSection extends StatelessWidget {
  final int currentXp;
  final int requiredXp;
  final int userLevel;

  const XpSection({
    Key? key,
    required this.currentXp,
    required this.requiredXp,
    required this.userLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Level indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.xpBarStart, AppColors.xpBarEnd],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonBlueGlow,
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'LEVEL $userLevel',
                      style: AppTextStyles.subtitleWhite.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // XP Progress Bar
          XpProgressBar(
            currentXp: currentXp,
            requiredXp: requiredXp,
            level: userLevel,
          ),
          const SizedBox(height: 8),
         
        ],
      ),
    );
  }
}