// death_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/data/widgets/custom_button.dart';
import '../controllers/death_controller.dart';

class DeathView extends GetView<DeathController> {
  const DeathView({Key? key}) : super(key: key);

  @override
  void initState() {
    // Set system overlay style to match the dark theme of death screen
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() => AnimatedOpacity(
          opacity: controller.isProcessing.value ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Broken Heart Animation
                Image.asset(
                  'assets/images/broken_heart.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 32),
                // Death Message
                Text(
                  'YOU HAVE DIED',
                  style: AppTextStyles.deathTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'You have failed your mission, Hunter. Your heart stops beating...',
                  style: AppTextStyles.deathMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Black Heart Option
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'USE BLACK HEART',
                        style: AppTextStyles.blackHeartTitle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Continue your journey without losing progress',
                        style: AppTextStyles.blackHeartDescription,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Image.asset(
                        'assets/images/black_heart.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'USE BLACK HEART (₹49)',
                        onPressed: controller.useBlackHeart,
                        isLoading: controller.isProcessing.value
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Reset Option
                TextButton(
                  onPressed: controller.isProcessing.value ? null : controller.resetProgress,
                  child: Text(
                    'START FROM THE BEGINNING',
                    style: AppTextStyles.resetText,
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}