// components/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';
import '../../controller/home_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return AppBar(
      title: Text(
        'ARISE',
        style: AppTextStyles.mainTitle.copyWith(
          foreground: Paint()
            ..shader = LinearGradient(
              colors: [Colors.white, AppColors.neonBlue],
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.appBarBackground,
      elevation: 4,
      shadowColor: AppColors.shadowDark.withOpacity(0.5),
      actions: [
        // Profile Button
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neonBlue, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonBlueGlow,
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => controller.goToProfile(),
          ),
        ),
        // Sign Out Button
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neonBlue.withOpacity(0.7), width: 1.5),
          ),
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => controller.signOut(),
          ),
          
          
        ),
        // Container(
        //   margin: const EdgeInsets.only(right: 8),
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     border: Border.all(color: AppColors.neonBlue.withOpacity(0.7), width: 1.5),
        //   ),
        //   child: IconButton(
        //     icon: const Icon(Icons.logout, color: Colors.white),
        //     onPressed: () => Get.toNamed("/streaks"),
        //   ),)
      ],
    );
  }
}