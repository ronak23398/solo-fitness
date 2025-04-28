import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Base font family
  static const String fontFamily = 'Poppins';
  
  // Main UI styles
  static final TextStyle mainTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static final TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.15,
  );
  
  static final TextStyle bodyText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.15,
  );
  
  // White text variants
  static final TextStyle headerWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static final TextStyle titleWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.25,
  );
  
  static final TextStyle subtitleWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.15,
  );
  
  static final TextStyle bodyWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.15,
  );
  
  static final TextStyle smallBodyWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.1,
  );
  
  static final TextStyle captionWhite = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.7),
    letterSpacing: 0.2,
  );
  
  // Black text variants
  static final TextStyle headerBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: 0.5,
  );
  
  static final TextStyle titleBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    letterSpacing: 0.25,
  );
  
  static final TextStyle subtitleBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: 0.15,
  );
  
  static final TextStyle bodyBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0.15,
  );
  
  static final TextStyle smallBodyBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0.1,
  );
  
  static final TextStyle captionBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black.withOpacity(0.7),
    letterSpacing: 0.2,
  );
  
  // Grey text variants
  static final TextStyle subtitleGrey = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.lightGrey,
    letterSpacing: 0.15,
  );
  
  static final TextStyle smallBodyGrey = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
    letterSpacing: 0.1,
  );
  
  // Input and hint text
  static final TextStyle inputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.15,
  );
  
  static final TextStyle hintText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
    letterSpacing: 0.15,
  );
  
  // Special text styles
  static final TextStyle levelUp = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.neonBlue,
    letterSpacing: 1.0,
    shadows: [
      Shadow(
        color: AppColors.neonBlueGlow,
        offset: Offset(0, 0),
        blurRadius: 10,
      ),
    ],
  );
  
  static final TextStyle classUpgrade = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.goldAccent,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        color: AppColors.goldAccent.withOpacity(0.7),
        offset: Offset(0, 0),
        blurRadius: 15,
      ),
    ],
  );
  
  static final TextStyle deathScreen = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.dangerRed,
    letterSpacing: 2.0,
    shadows: [
      Shadow(
        color: AppColors.deathRed,
        offset: Offset(0, 0),
        blurRadius: 20,
      ),
    ],
  );
  
  // Task and stat styles
  static final TextStyle taskTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.15,
  );
  
  static final TextStyle statValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static final TextStyle statLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.lightGrey,
    letterSpacing: 0.15,
  );
  
  static final TextStyle xpCounter = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.neonBlue,
    letterSpacing: 0.5,
  );
  
  // Button styles
  static final TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static final TextStyle buttonTextSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.25,
  );
  
  static final TextStyle buttonTextDisabled = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white.withOpacity(0.5),
    letterSpacing: 0.5,
  );
  
  // Class-specific text styles
  static final TextStyle eClass = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: const Color.fromARGB(255, 255, 55, 55),
    letterSpacing: 0.5,
  );
  
  static final TextStyle dClass = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.dClassColor,
    letterSpacing: 0.5,
  );
  
  static final TextStyle cClass = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.cClassColor,
    letterSpacing: 0.5,
  );
  
  static final TextStyle bClass = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.bClassColor,
    letterSpacing: 0.5,
  );
  
  static final TextStyle aClass = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.aClassColor,
    letterSpacing: 0.5,
  );
  
  static final TextStyle sClass = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.sClassColor,
    letterSpacing: 0.5,
    shadows: [
      Shadow(
        color: AppColors.sClassColor.withOpacity(0.7),
        offset: Offset(0, 0),
        blurRadius: 8,
      ),
    ],
  );
  
  static final TextStyle ssClass = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.ssClassColor,
    letterSpacing: 0.5,
    shadows: [
      Shadow(
        color: AppColors.ssClassColor.withOpacity(0.7),
        offset: Offset(0, 0),
        blurRadius: 12,
      ),
    ],
  );
  
  // Missing styles that caused errors
  
  // Neon blue variant
  static final TextStyle subtitleNeonBlue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.neonBlue,
    letterSpacing: 0.15,
    shadows: [
      Shadow(
        color: AppColors.neonBlueGlow,
        offset: Offset(0, 0),
        blurRadius: 3,
      ),
    ],
  );
  
  // Death screen related styles
  static final TextStyle deathTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.dangerRed,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        color: AppColors.deathRed,
        offset: Offset(0, 0),
        blurRadius: 15,
      ),
    ],
  );
  
  static final TextStyle deathMessage = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  // Black heart related styles
  static final TextStyle blackHeartTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: 0.5,
    shadows: [
      Shadow(
        color: Colors.purple.withOpacity(0.7),
        offset: Offset(0, 0),
        blurRadius: 5,
      ),
    ],
  );
  
  static final TextStyle blackHeartDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.25,
  );
  
  // Reset text style
  static final TextStyle resetText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.warningYellow,
    letterSpacing: 0.25,
  );
  
  // App bar title style
  static final TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.15,
  );
  
  // Timer text style
  static final TextStyle timerText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.neonBlue,
    letterSpacing: 0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  // Warning styles
  static final TextStyle warningTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.warningYellow,
    letterSpacing: 0.25,
  );
  
  static final TextStyle warningText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.15,
  );
}