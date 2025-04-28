import 'package:flutter/material.dart';
import 'package:solo_fitness/app/data/models/user_model.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';

class BlackHeartStatus extends StatelessWidget {
  final UserModel user;
  final VoidCallback onUseBlackHeart;
  final VoidCallback onNoBlackHearts;

  const BlackHeartStatus({
    super.key,
    required this.user,
    required this.onUseBlackHeart,
    required this.onNoBlackHearts,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'YOUR HUNTER HAS FALLEN',
              style: AppTextStyles.deathScreen,
            ),
            const SizedBox(height: 8),
            Text(
              'Use a Black Heart to continue your journey.',
              style: AppTextStyles.bodyText,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.favorite),
              label: Text(
                'USE BLACK HEART',
                style: AppTextStyles.buttonText,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: user.blackHearts > 0
                  ? onUseBlackHeart
                  : onNoBlackHearts,
            ),
          ],
        ),
      ),
    );
  }
}