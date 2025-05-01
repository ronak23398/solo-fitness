import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:solo_fitness/app/data/models/user_model.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/data/widgets/glowing_avatar.dart';
import 'package:solo_fitness/app/data/widgets/xp_progress_bar.dart';
import 'package:solo_fitness/app/modules/home/views/components/avatar_section.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final String currentClass;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.currentClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.deepBlue,
            AppColors.darkBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getClassColor(currentClass).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with class aura
          PlayerAvatarSection(),
          const SizedBox(height: 10),
          
          // Username with custom text style
          Text(
            user.username!.capitalize ?? 'Hunter',
            style: AppTextStyles.appBarTitle.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          
          // Class and Level with improved layout
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Class indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getClassColor(currentClass).withOpacity(0.2),
                  border: Border.all(
                    color: _getClassColor(currentClass),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  currentClass.toUpperCase(),
                  style: _getClassTextStyle(currentClass),
                ),
              ),
              
              // Level divider
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 24,
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              
              // Level indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonBlue.withOpacity(0.2),
                  border: Border.all(
                    color: AppColors.neonBlue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'LEVEL ${user.level}',
                  style: AppTextStyles.levelUp.copyWith(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
         
          const SizedBox(height: 24),
          
          // XP Progress with label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              XpProgressBar(
                currentXp: user.xp,
                requiredXp: user.xpToNextLevel(),
                level: user.level,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Helper method to build stat display items
  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
          ),
          child: Text(
            value.toString(),
            style: AppTextStyles.statValue.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.statLabel.copyWith(
            color: color.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
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
  
  // Custom text style based on class
  TextStyle _getClassTextStyle(String className) {
    switch (className) {
      case 'E-Class':
        return AppTextStyles.eClass.copyWith(fontSize: 18);
      case 'D-Class':
        return AppTextStyles.dClass.copyWith(fontSize: 18);
      case 'C-Class':
        return AppTextStyles.cClass.copyWith(fontSize: 18);
      case 'B-Class':
        return AppTextStyles.bClass.copyWith(fontSize: 18);
      case 'A-Class':
        return AppTextStyles.aClass.copyWith(fontSize: 18);
      case 'S-Class':
        return AppTextStyles.sClass.copyWith(fontSize: 18);
      case 'SS-Class':
        return AppTextStyles.ssClass.copyWith(fontSize: 18);
      default:
        return AppTextStyles.eClass.copyWith(fontSize: 18);
    }
  }
}