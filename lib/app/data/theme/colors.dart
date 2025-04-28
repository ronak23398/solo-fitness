import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color neonBlue = Color(0xFF01B4FF);
  static const Color purpleAccent = Color(0xFF8A2BE2);
  static const Color darkPurple = Color(0xFF1E0A33);
  static const Color primaryBlue = Color(0xFF3D5AFE);
  
  // Background colors
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkBlue = Color(0xFF141428);
  static const Color deepBlue = Color(0xFF0B0B2A);
  static const Color lightBlue = Color(0xFFEDF3FA);
  static const Color cardBackground = Color(0xFF1E1E2E);
  static const Color mediumBackground = Color(0xFF16161F);
  static const Color lightBackground = Color(0xFF1D1D2A);
  static const Color appBarBackground = Color(0xFF1A1A2E);
  static const Color warningButton = Color(0xFFFFC107);
  
  // Accent colors
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color neonPurple = Color(0xFFB026FF);
  
  // Status colors
  static const Color successGreen = Color(0xFF00E676);
  static const Color successDarkGreen = Color(0xFF00804A);
  static const Color dangerRed = Color(0xFFFF3D3D);
  static const Color dangerDarkRed = Color(0xFF8B0000);
  static const Color warningYellow = Color(0xFFFFD600);
  static const Color infoBlue = Color(0xFF2196F3);
  static const Color darkRed = Color(0xFFB71C1C);
  
  // Grey scale
  static const Color darkGrey = Color(0xFF383848);
  static const Color mediumGrey = Color(0xFF666680);
  static const Color lightGrey = Color(0xFFABACBE);
  static const Color textLight = Color(0xFFF4F4F6);
  static const Color textLightDisabled = Color(0xFFA0A0A8); // Added for disabled text
  
  // Class colors
  static const Color classE = Color(0xFF888888);  // E-Class color
  static const Color classD = Color(0xFF4CAF50);  // D-Class color
  static const Color classC = Color(0xFF2196F3);  // C-Class color
  static const Color classB = Color(0xFF9C27B0);  // B-Class color
  static const Color classA = Color(0xFFFF9800);  // A-Class color
  static const Color classS = Color(0xFFFF5722);  // S-Class color
  static const Color classSS = Color(0xFFFF0000); // SS-Class color
  
  // Original class colors (keeping for compatibility)
  static const Color eClassColor = Color(0xFF888888);
  static const Color dClassColor = Color(0xFF4CAF50);
  static const Color cClassColor = Color(0xFF2196F3);
  static const Color bClassColor = Color(0xFF9C27B0);
  static const Color aClassColor = Color(0xFFFF9800);
  static const Color sClassColor = Color(0xFFFF5722);
  static const Color ssClassColor = Color(0xFFFF0000);
  
  // Stat colors
  static const Color strengthColor = Color(0xFFE91E63);
  static const Color enduranceColor = Color(0xFF4CAF50);
  static const Color agilityColor = Color(0xFFFFEB3B);
  static const Color intelligenceColor = Color(0xFF2196F3);
  static const Color disciplineColor = Color(0xFF9C27B0);
  
  // Death screen
  static const Color blackHeartColor = Color(0xFF000000);
  static const Color deathRed = Color(0xFF5E0000);
  
  // Shadow and gradient colors
  static const Color shadowDark = Color(0xFF05050A);
  static const Color neonBlueGlow = Color(0x5001B4FF);
  static const Color levelUpGlow = Color(0x8001B4FF);
  
  // Level up gradient colors
  static List<Color> levelUpGradient = [
    neonBlue.withOpacity(0.7),
    purpleAccent.withOpacity(0.7),
  ];
  
  // Class upgrade gradient colors
  static List<Color> classUpgradeGradient = [
    goldAccent.withOpacity(0.7),
    neonPurple.withOpacity(0.7),
  ];
  
  // Task difficulty colors
  static const Color easyDifficulty = Color(0xFF81C784);  // Added to match the UI
  static const Color mediumDifficulty = Color(0xFFFFD54F);  // Added to match the UI
  static const Color hardDifficulty = Color(0xFFFF8A65);  // Added to match the UI
  static const Color extremeDifficulty = Color(0xFFE57373);  // Added to match the UI
  
  // For task reward chips
  static const Color statPointsBg = Color(0xFF263238);  // Added for stat points background
  static const Color statPointsText = Color(0xFF4CAF50);  // Added for stat points text
  static const Color xpPointsBg = Color(0xFF0D47A1);  // Added for XP points background
  static const Color xpPointsText = Color(0xFF64B5F6);  // Added for XP points text
  
  // XP bar colors
  static const Color xpBarStart = Color(0xFF2979FF);
  static const Color xpBarEnd = Color(0xFF00E5FF);
}