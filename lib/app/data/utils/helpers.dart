// helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import 'constants.dart';

class Helpers {
  // Date and Time Helpers
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }
  
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
  
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
  
  static bool isTaskDeadlinePassed() {
    final now = DateTime.now();
    final deadlineTime = DateTime(
      now.year, 
      now.month, 
      now.day, 
      Constants.taskDeadlineHour, 
      Constants.taskDeadlineMinute
    );
    
    return now.isAfter(deadlineTime);
  }
  
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
  // Player Class Helpers
  static String getClassFromLevel(int level) {
    if (level <= Constants.eClassMaxLevel) {
      return Constants.eClass;
    } else if (level <= Constants.dClassMaxLevel) {
      return Constants.dClass;
    } else if (level <= Constants.cClassMaxLevel) {
      return Constants.cClass;
    } else if (level <= Constants.bClassMaxLevel) {
      return Constants.bClass;
    } else if (level <= Constants.aClassMaxLevel) {
      return Constants.aClass;
    } else if (level <= Constants.sClassMaxLevel) {
      return Constants.sClass;
    } else {
      return Constants.ssClass;
    }
  }
  
  static Color getClassColor(String playerClass) {
    switch (playerClass) {
      case Constants.eClass:
        return AppColors.eClassColor;
      case Constants.dClass:
        return AppColors.dClassColor;
      case Constants.cClass:
        return AppColors.cClassColor;
      case Constants.bClass:
        return AppColors.bClassColor;
      case Constants.aClass:
        return AppColors.aClassColor;
      case Constants.sClass:
        return AppColors.sClassColor;
      case Constants.ssClass:
        return AppColors.ssClassColor;
      default:
        return AppColors.eClassColor;
    }
  }
  
  static TextStyle getClassTextStyle(String playerClass) {
    switch (playerClass) {
      case Constants.eClass:
        return Get.textTheme.headlineMedium!.copyWith(color: AppColors.eClassColor);
      case Constants.dClass:
        return Get.textTheme.headlineMedium!.copyWith(color: AppColors.dClassColor);
      case Constants.cClass:
        return Get.textTheme.headlineMedium!.copyWith(color: AppColors.cClassColor);
      case Constants.bClass:
        return Get.textTheme.headlineMedium!.copyWith(color: AppColors.bClassColor);
      case Constants.aClass:
        return Get.textTheme.headlineMedium!.copyWith(color: AppColors.aClassColor);
      case Constants.sClass:
        return Get.textTheme.headlineMedium!.copyWith(
          color: AppColors.sClassColor,
          shadows: [
            Shadow(
              color: AppColors.sClassColor.withOpacity(0.7),
              offset: Offset(0, 0),
              blurRadius: 8,
            ),
          ],
        );
      case Constants.ssClass:
        return Get.textTheme.headlineMedium!.copyWith(
          color: AppColors.ssClassColor,
          fontWeight: FontWeight.w800,
          shadows: [
            Shadow(
              color: AppColors.ssClassColor.withOpacity(0.7),
              offset: Offset(0, 0),
              blurRadius: 12,
            ),
          ],
        );
      default:
        return Get.textTheme.headlineMedium!;
    }
  }
  
  // XP and Level Helpers
  static int calculateXPForLevel(int level) {
    // Formula: each level requires base 100 XP + 20 XP per previous level
    return 100 + (level - 1) * 20;
  }
  
  static int calculateTotalXPForLevel(int level) {
    // Total XP needed to reach this level from level 1
    int totalXP = 0;
    for (int i = 1; i < level; i++) {
      totalXP += calculateXPForLevel(i);
    }
    return totalXP;
  }
  
  static bool hasLeveledUp(int previousTotalXP, int newTotalXP) {
    int prevLevel = getLevelFromTotalXP(previousTotalXP);
    int newLevel = getLevelFromTotalXP(newTotalXP);
    return newLevel > prevLevel;
  }
  
  static bool hasClassUpgraded(int previousTotalXP, int newTotalXP) {
    int prevLevel = getLevelFromTotalXP(previousTotalXP);
    int newLevel = getLevelFromTotalXP(newTotalXP);
    
    String prevClass = getClassFromLevel(prevLevel);
    String newClass = getClassFromLevel(newLevel);
    
    return prevClass != newClass;
  }
  
  static int getLevelFromTotalXP(int totalXP) {
    int level = 1;
    int xpRequired = calculateXPForLevel(level);
    int xpSoFar = 0;
    
    while (xpSoFar + xpRequired <= totalXP) {
      xpSoFar += xpRequired;
      level++;
      xpRequired = calculateXPForLevel(level);
    }
    
    return level;
  }
  
  static int getCurrentLevelXP(int totalXP) {
    int level = getLevelFromTotalXP(totalXP);
    int totalXPForPreviousLevel = calculateTotalXPForLevel(level);
    return totalXP - totalXPForPreviousLevel;
  }
  
  static int getXPForCurrentLevel(int totalXP) {
    int level = getLevelFromTotalXP(totalXP);
    return calculateXPForLevel(level);
  }
  
  static double getLevelProgress(int totalXP) {
    int currentLevelXP = getCurrentLevelXP(totalXP);
    int xpForLevel = getXPForCurrentLevel(totalXP);
    return currentLevelXP / xpForLevel;
  }
  
  // Stat Category Helpers
  static Color getStatColor(String category) {
    switch (category) {
      case Constants.strengthCategory:
        return AppColors.strengthColor;
      case Constants.enduranceCategory:
        return AppColors.enduranceColor;
      case Constants.agilityCategory:
        return AppColors.agilityColor;
      case Constants.intelligenceCategory:
        return AppColors.intelligenceColor;
      case Constants.disciplineCategory:
        return AppColors.disciplineColor;
      default:
        return AppColors.neonBlue;
    }
  }
  
  static IconData getStatIcon(String category) {
    switch (category) {
      case Constants.strengthCategory:
        return Icons.fitness_center;
      case Constants.enduranceCategory:
        return Icons.directions_run;
      case Constants.agilityCategory:
        return Icons.speed;
      case Constants.intelligenceCategory:
        return Icons.psychology;
      case Constants.disciplineCategory:
        return Icons.timer;
      default:
        return Icons.star;
    }
  }
  
  // Task Difficulty Helpers
  static int getStatPointsForDifficulty(String difficulty) {
    switch (difficulty) {
      case Constants.easyDifficulty:
        return Constants.easyTaskStatPoints;
      case Constants.mediumDifficulty:
        return Constants.mediumTaskStatPoints;
      case Constants.hardDifficulty:
        return Constants.hardTaskStatPoints;
      case Constants.extremeDifficulty:
        return Constants.extremeTaskStatPoints;
      default:
        return Constants.easyTaskStatPoints;
    }
  }
  
  static int getXPForDifficulty(String difficulty) {
    switch (difficulty) {
      case Constants.easyDifficulty:
        return Constants.easyTaskXP;
      case Constants.mediumDifficulty:
        return Constants.mediumTaskXP;
      case Constants.hardDifficulty:
        return Constants.hardTaskXP;
      case Constants.extremeDifficulty:
        return Constants.extremeTaskXP;
      default:
        return Constants.easyTaskXP;
    }
  }
  
  static Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case Constants.easyDifficulty:
        return AppColors.successGreen;
      case Constants.mediumDifficulty:
        return AppColors.warningYellow;
      case Constants.hardDifficulty:
        return AppColors.neonPurple;
      case Constants.extremeDifficulty:
        return AppColors.dangerRed;
      default:
        return AppColors.successGreen;
    }
  }
  
  // Streak Helpers
  static int getStreakXPBonus(int streakDays) {
    if (streakDays >= Constants.longStreakDays) {
      return Constants.longStreakXPBonus;
    } else if (streakDays >= Constants.mediumStreakDays) {
      return Constants.mediumStreakXPBonus;
    } else if (streakDays >= Constants.shortStreakDays) {
      return Constants.shortStreakXPBonus;
    } else {
      return 0;
    }
  }
  
  // Storage Helpers
  static Future<bool> saveToStorage(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      return await prefs.setStringList(key, value);
    }
    
    return false;
  }
  
  static Future<dynamic> getFromStorage(String key, dynamic defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (defaultValue is String) {
      return prefs.getString(key) ?? defaultValue;
    } else if (defaultValue is int) {
      return prefs.getInt(key) ?? defaultValue;
    } else if (defaultValue is bool) {
      return prefs.getBool(key) ?? defaultValue;
    } else if (defaultValue is double) {
      return prefs.getDouble(key) ?? defaultValue;
    } else if (defaultValue is List<String>) {
      return prefs.getStringList(key) ?? defaultValue;
    }
    
    return defaultValue;
  }
  
  static Future<bool> removeFromStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
  
  static Future<bool> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
  
  // UI Helpers
  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.successGreen.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(8),
      borderRadius: 10,
      duration: Duration(seconds: 3),
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }
  
  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.dangerRed.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(8),
      borderRadius: 10,
      duration: Duration(seconds: 4),
      icon: Icon(Icons.error, color: Colors.white),
    );
  }
  
  static void showWarningSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warningYellow.withOpacity(0.8),
      colorText: Colors.black,
      margin: EdgeInsets.all(8),
      borderRadius: 10,
      duration: Duration(seconds: 4),
      icon: Icon(Icons.warning, color: Colors.black),
    );
  }
  
  static void showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required Function onConfirm,
    required Function onCancel,
    Color? confirmColor,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onCancel();
            },
            child: Text(cancelText),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lightGrey,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmText),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? AppColors.neonBlue,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}