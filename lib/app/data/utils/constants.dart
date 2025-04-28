// constants.dart
class Constants {
  // App Information
  static const String appName = "Solo Hunter";
  static const String appVersion = "1.0.0";
  
  // Firebase Collections
  static const String usersCollection = "users";
  static const String tasksCollection = "daily_tasks";
  static const String penaltyTasksCollection = "penalty_tasks";
  
  // Storage Keys
  static const String userIdKey = "user_id";
  static const String userTokenKey = "user_token";
  static const String darkModeKey = "dark_mode";
  static const String notificationEnabledKey = "notifications_enabled";
  static const String firstLaunchKey = "first_launch";
  static const String lastLoginDateKey = "last_login_date";
  
  // Task Categories
  static const String strengthCategory = "Strength";
  static const String enduranceCategory = "Endurance";
  static const String agilityCategory = "Agility";
  static const String intelligenceCategory = "Intelligence";
  static const String disciplineCategory = "Discipline";
  
  // Task Difficulties
  static const String easyDifficulty = "Easy";
  static const String mediumDifficulty = "Medium";
  static const String hardDifficulty = "Hard";
  static const String extremeDifficulty = "Extreme";
  
  // Points and XP Values
  static const int easyTaskStatPoints = 2;
  static const int mediumTaskStatPoints = 4;
  static const int hardTaskStatPoints = 6;
  static const int extremeTaskStatPoints = 10;
  
  static const int easyTaskXP = 10;
  static const int mediumTaskXP = 25;
  static const int hardTaskXP = 50;
  static const int extremeTaskXP = 100;
  
  // Player Classes
  static const String eClass = "E-Class";
  static const String dClass = "D-Class";
  static const String cClass = "C-Class";
  static const String bClass = "B-Class";
  static const String aClass = "A-Class";
  static const String sClass = "S-Class";
  static const String ssClass = "SS-Class";
  
  // Level Ranges for Classes
  static const int eClassMaxLevel = 10;
  static const int dClassMaxLevel = 20;
  static const int cClassMaxLevel = 35;
  static const int bClassMaxLevel = 50;
  static const int aClassMaxLevel = 70;
  static const int sClassMaxLevel = 85;
  static const int ssClassMaxLevel = 100;
  
  // Notification IDs
  static const int dailyReminderNotificationId = 1;
  static const int taskCompletionNotificationId = 2;
  static const int levelUpNotificationId = 3;
  static const int classUpgradeNotificationId = 4;
  static const int penaltyNotificationId = 5;
  static const int deathNotificationId = 6;
  
  // Animation Durations
  static const int levelUpAnimationDuration = 2000; // milliseconds
  static const int classUpgradeAnimationDuration = 3500; // milliseconds
  static const int taskCompletionAnimationDuration = 800; // milliseconds
  static const int deathAnimationDuration = 3000; // milliseconds
  
  // Streaks
  static const int shortStreakDays = 3;
  static const int mediumStreakDays = 7;
  static const int longStreakDays = 30;
  
  static const int shortStreakXPBonus = 50;
  static const int mediumStreakXPBonus = 150;
  static const int longStreakXPBonus = 500;
  
  // Black Heart
  static const String blackHeartProductId = "black_heart_revive";
  static const String blackHeartTitle = "Black Heart";
  static const String blackHeartDescription = "Resurrect and continue your journey";
  
  // Special Messages
  static const String deathMessage = "You have failed your mission, Hunter. Your heart stops beating...";
  static const String reviveMessage = "The Black Heart pulses with forbidden power. Will you accept its offer?";
  static const String dailyTaskReminderMessage = "Your quests await, Hunter. Prove your worth today.";
  
  // Time Constants
  static const int dayInMilliseconds = 24 * 60 * 60 * 1000;
  static const int taskDeadlineHour = 23; // 11 PM
  static const int taskDeadlineMinute = 59;
  static const int dailyReminderHour = 7; // 7 AM
  static const int dailyReminderMinute = 0;
  
  // URLs
  static const String termsOfServiceUrl = "https://soloapp.com/terms";
  static const String privacyPolicyUrl = "https://soloapp.com/privacy";
  static const String supportUrl = "https://soloapp.com/support";
}