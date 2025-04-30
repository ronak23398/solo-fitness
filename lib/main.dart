import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solo_fitness/app/data/services/auth_service.dart';
import 'package:solo_fitness/app/data/services/database_services/services_binding.dart';
import 'package:solo_fitness/app/data/theme/app_theme.dart';
import 'package:solo_fitness/app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
   ServiceBinding().dependencies();
  // Initialize GetStorage for local storage
  await GetStorage.init();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(SoloFitnessApp());
}

class SoloFitnessApp extends StatelessWidget {
  // Register AuthService as a dependency
  final AuthService _authService = Get.put(AuthService());
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Solo Fitness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme
      defaultTransition: Transition.fadeIn,
      initialRoute: AppRoutes.SPLASH, // Start with splash screen
      getPages: AppPages.pages,
    );
  }
}