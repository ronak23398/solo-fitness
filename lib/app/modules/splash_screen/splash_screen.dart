import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/services/auth_service.dart';
import 'package:solo_fitness/app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Use post-frame callback to navigate after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToProperScreen();
    });
  }
  
  void _navigateToProperScreen() async {
    // Get reference to auth service
    final AuthService authService = Get.find<AuthService>();
    
    // Wait for authentication to initialize (with timeout)
    int attempts = 0;
    while (!authService.isInitialized.value && attempts < 50) {
      await Future.delayed(Duration(milliseconds: 100));
      attempts++;
    }
    
    // After initialization or timeout, check auth state
    if (authService.currentUser.value != null) {
      // User is logged in
      if (authService.currentUser.value!.isDead) {
        Get.offAllNamed(AppRoutes.DEATH_SCREEN);
      } else {
        Get.offAllNamed(AppRoutes.HOME);
      }
    } else {
      // User is not logged in
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can add your logo here
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}