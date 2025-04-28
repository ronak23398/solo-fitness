// app_theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.neonBlue,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkBlue,
      dividerColor: AppColors.darkGrey,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkPurple,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headerWhite,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headerWhite,
        headlineMedium: AppTextStyles.titleWhite,
        titleMedium: AppTextStyles.subtitleWhite,
        bodyLarge: AppTextStyles.bodyWhite,
        bodyMedium: AppTextStyles.smallBodyWhite,
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.neonBlue,
        secondary: AppColors.purpleAccent,
        surface: AppColors.darkBlue,
        background: AppColors.darkBackground,
        error: AppColors.dangerRed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neonBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.dangerRed, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.lightGrey),
        hintStyle: TextStyle(color: AppColors.lightGrey.withOpacity(0.7)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.neonBlue;
          }
          return AppColors.lightGrey;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.neonBlue.withOpacity(0.5);
          }
          return AppColors.darkGrey;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.neonBlue;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: AppColors.lightGrey),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.neonBlue,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.darkBlue,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: AppTextStyles.titleWhite,
        contentTextStyle: AppTextStyles.bodyWhite,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkPurple,
        selectedItemColor: AppColors.neonBlue,
        unselectedItemColor: AppColors.lightGrey,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkBlue,
        contentTextStyle: TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.neonBlue,
        unselectedLabelColor: AppColors.lightGrey,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.neonBlue, width: 3),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.darkPurple,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(color: Colors.white),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.neonBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.purpleAccent,
      scaffoldBackgroundColor: Colors.white,
      cardColor: AppColors.lightBlue,
      dividerColor: AppColors.lightGrey,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.purpleAccent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headerBlack,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headerBlack,
        headlineMedium: AppTextStyles.titleBlack,
        titleMedium: AppTextStyles.subtitleBlack,
        bodyLarge: AppTextStyles.bodyBlack,
        bodyMedium: AppTextStyles.smallBodyBlack,
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.purpleAccent,
        secondary: AppColors.neonBlue,
        surface: AppColors.lightBlue,
        background: Colors.white,
        error: AppColors.dangerRed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          elevation: 4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.purpleAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.dangerRed, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.black87),
        hintStyle: TextStyle(color: Colors.black54),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.purpleAccent;
          }
          return AppColors.darkGrey;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.purpleAccent.withOpacity(0.5);
          }
          return AppColors.lightGrey;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.purpleAccent;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: AppColors.darkGrey),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.purpleAccent,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.lightBlue,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: AppTextStyles.titleBlack,
        contentTextStyle: AppTextStyles.bodyBlack,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.purpleAccent,
        unselectedItemColor: AppColors.darkGrey,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightBlue,
        contentTextStyle: TextStyle(color: Colors.black87),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.purpleAccent,
        unselectedLabelColor: AppColors.darkGrey,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.purpleAccent, width: 3),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(color: Colors.black87),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.purpleAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}