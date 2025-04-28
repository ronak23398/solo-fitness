// levelup_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/data/widgets/custom_button.dart';
import '../controllers/levelup_controller.dart';

class LevelupView extends GetView<LevelupController> {
  const LevelupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Level Up Icon
                _buildLevelUpIcon(),
                const SizedBox(height: 24),
                
                // Level Up Text
                Text(
                  controller.isClassUpgrade.value ? 'CLASS UP!' : 'LEVEL UP!',
                  style: AppTextStyles.levelUp,
                ),
                const SizedBox(height: 16),
                
                // Message
                Text(
                  controller.getLevelUpMessage(),
                  style: AppTextStyles.levelUp,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Level or Class Change
                controller.isClassUpgrade.value
                    ? _buildClassUpgradeDisplay()
                    : _buildLevelChangeDisplay(),
                
                const SizedBox(height: 48),
                
                // Continue Button
                CustomButton(
                  text: 'CONTINUE',
                  onPressed: controller.continueToDashboard,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
  
  Widget _buildAnimatedBackground() {
    // Animated gradient background
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: controller.isClassUpgrade.value
              ? [
                  _getClassColor(controller.newClass.value).withOpacity(0.8),
                  Colors.black,
                ]
              : [
                  AppColors.primaryBlue.withOpacity(0.5),
                  Colors.black,
                ],
        ),
      ),
    );
  }
  
  Widget _buildLevelUpIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: controller.isClassUpgrade.value
            ? _getClassColor(controller.newClass.value)
            : AppColors.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: controller.isClassUpgrade.value
                ? _getClassColor(controller.newClass.value).withOpacity(0.5)
                : AppColors.primaryBlue.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Icon(
        controller.isClassUpgrade.value ? Icons.emoji_events : Icons.arrow_upward,
        size: 60,
        color: Colors.white,
      ),
    );
  }
  
  Widget _buildLevelChangeDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${controller.previousLevel.value}',
          style: AppTextStyles.statLabel,
        ),
        const SizedBox(width: 16),
        const Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(width: 16),
        Text(
          '${controller.newLevel.value}',
          style: AppTextStyles.levelUp,
        ),
      ],
    );
  }
  
  Widget _buildClassUpgradeDisplay() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getClassColor(controller.previousClass.value).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getClassColor(controller.previousClass.value),
                  width: 1,
                ),
              ),
              child: Text(
                controller.previousClass.value,
                style: TextStyle(
                  color: _getClassColor(controller.previousClass.value),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getClassColor(controller.newClass.value).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getClassColor(controller.newClass.value),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getClassColor(controller.newClass.value).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                controller.newClass.value,
                style: TextStyle(
                  color: _getClassColor(controller.newClass.value),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'New abilities unlocked!',
          style: AppTextStyles.subtitleNeonBlue,
        ),
      ],
    );
  }
  
  Color _getClassColor(String className) {
    switch (className) {
      case 'E-Class':
        return AppColors.eClassColor;
      case 'D-Class':
        return AppColors.dClassColor;
      case 'C-Class':
        return AppColors.cClassColor;
      case 'B-Class':
        return AppColors.bClassColor;
      case 'A-Class':
        return AppColors.aClassColor;
      case 'S-Class':
        return AppColors.sClassColor;
      case 'SS-Class':
        return AppColors.ssClassColor;
      default:
        return AppColors.eClassColor;
    }
  }
}