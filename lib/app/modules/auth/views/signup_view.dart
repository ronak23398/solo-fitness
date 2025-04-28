// register_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/data/widgets/custom_button.dart';
import 'package:solo_fitness/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(  // Add Form widget here
              key: controller.registerFormKey,  // Connect the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // App Logo
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.textLight),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'CREATE ACCOUNT',
                    style: AppTextStyles.mainTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Begin your journey as a Hunter',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Username Field
                  TextFormField(  // Changed to TextFormField for validation
                    controller: controller.nameController,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: AppTextStyles.hintText,
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.person, color: AppColors.textLight),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Email Field
                  TextFormField(  // Changed to TextFormField for validation
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  Obx(() => TextFormField(  // Changed to TextFormField for validation
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value, // Fix visibility logic (it was inverted)
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
                      prefixIcon: Icon(Icons.lock, color: AppColors.textLight),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textLight,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 16),
                  // Confirm Password Field
                  Obx(() => TextFormField(  
                    controller: controller.confirmPasswordController, 
                    obscureText: !controller.isPasswordVisible.value, 
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: AppTextStyles.hintText,
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != controller.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 30),
                  // Register Button
                  Obx(() => CustomButton(
                    text: 'REGISTER',
                    onPressed: controller.registerWithEmailAndPassword,
                    isLoading: controller.isLoading.value,
                  )),
                  const SizedBox(height: 24),
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.bodyText,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'LOGIN',
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