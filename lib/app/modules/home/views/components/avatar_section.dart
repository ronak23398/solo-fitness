// components/player_avatar_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';
import '../../controller/home_controller.dart';

class PlayerAvatarSection extends StatelessWidget {
  const PlayerAvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonBlueGlow.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 15,
                ),
              ],
            ),
          ),
          // Inner glow
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonBlue, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonBlueGlow,
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // Avatar
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.cardBackground,
            backgroundImage: AssetImage('assets/images/sung.jpg'),
          ),
          // Class indicator
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _getClassColor(controller.userClass.value), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _getClassColor(controller.userClass.value).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Text(
                'CLASS ${controller.userClass.value}',
                style: _getClassTextStyle(controller.userClass.value),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
 

  // Get appropriate text style based on player class
  TextStyle _getClassTextStyle(String playerClass) {
    switch (playerClass) {
      case 'E':
        return AppTextStyles.eClass;
      case 'D':
        return AppTextStyles.dClass;
      case 'C':
        return AppTextStyles.cClass;
      case 'B':
        return AppTextStyles.bClass;
      case 'A':
        return AppTextStyles.aClass;
      case 'S':
        return AppTextStyles.sClass;
      case 'SS':
        return AppTextStyles.ssClass;
      default:
        return AppTextStyles.eClass;
    }
  }
  
  // Get appropriate color based on player class
  Color _getClassColor(String playerClass) {
    switch (playerClass) {
      case 'E':
        return Colors.grey;
      case 'D':
        return Colors.green;
      case 'C':
        return Colors.blue;
      case 'B':
        return Colors.purple;
      case 'A':
        return Colors.orange;
      case 'S':
        return Colors.red;
      case 'SS':
        return AppColors.goldAccent;
      default:
        return Colors.grey;
    }
  }
}