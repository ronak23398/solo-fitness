// components/penalty_warning.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';

class PenaltyWarning extends StatelessWidget {
  const PenaltyWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          color: AppColors.deathRed,
          child: Column(
            children: [
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [Colors.red, Colors.orange.shade900],
                    ).createShader(bounds),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'PENALTY MISSIONS ACTIVE',
                style: AppTextStyles.headerWhite.copyWith(
                  letterSpacing: 2,
                  shadows: [Shadow(color: AppColors.dangerRed, blurRadius: 10)],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You failed to complete yesterday\'s tasks.',
                style: AppTextStyles.bodyWhite,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Complete penalty tasks today or face death.',
                style: AppTextStyles.warningText.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Add a small delay to prevent rapid navigation
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Get.toNamed('/penalty');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'VIEW PENALTY MISSIONS',
                  style: AppTextStyles.buttonText.copyWith(
                    color: AppColors.dangerRed,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Warning graphic below
        Expanded(
          child: Container(
            color: AppColors.darkBackground,
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: AppColors.dangerRed,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'One more failure will result in death.',
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.lightGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
