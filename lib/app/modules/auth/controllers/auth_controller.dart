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
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController confirmPasswordController;
  
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  
  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }
  
  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
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
      
      // Show a loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      
      // Add a short delay to ensure backend processes complete
      await Future.delayed(const Duration(seconds: 2));
      
      // Close the dialog
      Get.back();
      
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
      
      // Show success snackbar
      Get.snackbar(
        'Registration Successful',
        'Please login with your credentials',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // IMPORTANT: Capture the values we need before navigation
      final email = emailController.text.trim();
      
      // Navigate to login page after successful registration
      // Using Get.offAll instead of Get.offAllNamed to ensure complete removal of previous routes
      Get.offAll(
        () => Get.toNamed(AppRoutes.LOGIN),
        transition: Transition.rightToLeft,
      );
      
      // Wait for the new controller to be initialized in the login page
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Pre-fill the email field on the login page (optional)
      final newController = Get.find<AuthController>();
      newController.emailController.text = email;
      
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
  
  // Clear all form fields
  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
  }
  
  // Navigate to Register screen
  void goToRegister() {
    clearFormFields();
    Get.toNamed('/register');
  }
  
  // Navigate to Login screen
  void goToLogin() {
    clearFormFields();
    Get.toNamed('/login');
  }
  
  // Navigate to Forgot Password screen
  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}