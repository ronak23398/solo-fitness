import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  // Observables
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  // Login form key
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  
  
  @override
void onClose() {
  emailController.dispose();
  passwordController.dispose();
  nameController.dispose();
  confirmPasswordController.dispose();
  super.onClose();
}
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  // Handle login with email and password
  // Handle login with email and password
// Handle login with email and password
Future<void> loginWithEmailAndPassword() async {
  // Check if the form state exists before validating
  if (loginFormKey.currentState == null || !loginFormKey.currentState!.validate()) {
    // If form key is null or validation fails
    if (loginFormKey.currentState == null) {
      Get.snackbar(
        'Login Error',
        'Form not initialized properly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return;
  }
  
  try {
    isLoading.value = true;
    
    await _authService.signInWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text,
    );
    
    // Clear form
    emailController.clear();
    passwordController.clear();
    
    // Navigate to home page after successful login
    Get.offAllNamed(AppRoutes.HOME);
    
  } catch (e) {
    Get.snackbar(
      'Login Failed',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

// Handle registration with email and password
Future<void> registerWithEmailAndPassword() async {
  // Check if the form state exists before validating
  if (registerFormKey.currentState == null || !registerFormKey.currentState!.validate()) {
    // If form key is null or validation fails
    if (registerFormKey.currentState == null) {
      Get.snackbar(
        'Registration Error',
        'Form not initialized properly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return;
  }
  
  try {
    isLoading.value = true;
    
    await _authService.registerWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text,
      nameController.text.trim(),
    );
    
    // Clear form
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    
    // Navigate to home page after successful registration
    Get.offAllNamed(AppRoutes.HOME);
    
  } catch (e) {
    Get.snackbar(
      'Registration Failed',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}
  
  // Handle login with Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      await _authService.signInWithGoogle();
    } catch (e) {
      Get.snackbar(
        'Google Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Handle password reset
  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Reset Password Failed',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isLoading.value = true;
      await _authService.resetPassword(emailController.text.trim());
      
      Get.snackbar(
        'Password Reset',
        'Password reset email has been sent to ${emailController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Reset Password Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Navigate to Register screen
  void goToRegister() {
    Get.toNamed('/register');
  }
  
  // Navigate to Login screen
  void goToLogin() {
    Get.toNamed('/login');
  }
  
  // Navigate to Forgot Password screen
  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}