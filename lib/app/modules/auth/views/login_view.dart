// login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/data/widgets/custom_button.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // App Logo
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.fitness_center,
                          size: 60,
                          color: AppColors.darkBackground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'ARISE',
                    style: AppTextStyles.mainTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Train. Level Up. Become Stronger.',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  // Email Field
                  TextField(
                    controller: controller.emailController,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: AppTextStyles.hintText,
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.email, color: AppColors.textLight),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  Obx(
                    () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordVisible.value,
                      style: AppTextStyles.inputText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: AppTextStyles.hintText,
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.textLight,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textLight,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Login Button
                  Obx(
                    () => CustomButton(
                      text: 'LOGIN',
                      onPressed: controller.loginWithEmailAndPassword,
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: AppTextStyles.bodyText,
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/register'),
                        child: Text(
                          'REGISTER',
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
