import 'package:get/get.dart';
import 'package:solo_fitness/app/data/services/database_service.dart';
import 'package:solo_fitness/app/data/services/firebasetasksupload.dart';
import 'dart:async';
import '../../../data/models/task_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  // final NotificationService _notificationService = Get.find<NotificationService>();
  
  // Observables
  RxBool isLoading = false.obs;
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);
  
  // Added observables based on home_view requirements
  RxBool hasPenaltyMissions = false.obs;
  RxBool userDied = false.obs;
  RxInt userLevel = 1.obs;
  RxString userClass = 'E'.obs;
  RxInt currentXp = 0.obs;
  RxInt requiredXp = 100.obs;
  RxString formattedTimeRemaining = '24:00:00'.obs;
  RxInt currentStreak = 0.obs;
  RxBool hasStreakReward = false.obs;
  // Track the current day the user is on
  RxInt currentDay = 1.obs;
  
  Timer? _timer;
  
  @override
  void onInit() {
    super.onInit();
    user.value = _authService.currentUser.value;
    // Fetch the current day first, then load tasks
    _fetchUserCurrentDay();
    _startDailyTimer();
    _updateUserStats();
    checkExpiredTasks();
    // _notificationService.scheduleDailyReminder();
  }
  
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
  
  // Fetch the current day for the user
  Future<void> _fetchUserCurrentDay() async {
    if (user.value?.id == null) return;
    
    try {
      // Get current day from user profile
      final day = await _databaseService.getCurrentUserDay(user.value!.id!);
      currentDay.value = day;
      print("Current day for user ${user.value!.id}: ${currentDay.value}");
      
      // Now load tasks for this day
      await loadTasks();
    } catch (e) {
      print("Error fetching current day: $e");
      // Default to day 1 if there's an error
      currentDay.value = 1;
      await loadTasks();
    }
  }
  
  // Update user stats from the user model
  void _updateUserStats() {
    if (user.value != null) {
      userLevel.value = user.value!.level;
      userClass.value = user.value!.playerClass;
      currentXp.value = user.value!.xp;
      requiredXp.value = user.value!.requiredXpForNextLevel;
      // Fix: Use currentStreak property from the UserStreak object
      currentStreak.value = user.value!.streak.currentStreak;
      hasStreakReward.value = user.value!.hasStreakReward();
    }
  }
  
  // Start timer to count down to daily reset
  void _startDailyTimer() {
    // Calculate time until midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);
    
    _updateTimeRemaining(timeUntilMidnight);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final timeUntilMidnight = tomorrow.difference(now);
      
      _updateTimeRemaining(timeUntilMidnight);
      
      // Check for expired tasks every minute
      if (now.second == 0) {
        checkExpiredTasks();
      }
      
      // Reset tasks at midnight
      if (timeUntilMidnight.inSeconds <= 0) {
        _handleDayReset();
      }
    });
  }
  
  // Handle day reset at midnight
  void _handleDayReset() {
    // Advance to next day if all tasks are completed
    if (_canAdvanceToNextDay()) {
      _advanceToNextDay();
    } else {
      // Otherwise just refresh tasks
      loadTasks();
    }
  }
  
  // Check if user can advance to next day
  bool _canAdvanceToNextDay() {
    // Logic to determine if user can advance
    // For example, if all non-penalty tasks are completed
    final nonPenaltyTasks = tasks.where((task) => !task.isPenalty).toList();
    final allNonPenaltyCompleted = nonPenaltyTasks.every(
        (task) => task.status == TaskStatus.completed);
    
    return allNonPenaltyCompleted;
  }
  
  // Advance user to next day
  Future<void> _advanceToNextDay() async {
    if (user.value == null) return;
    
    try {
      // Call database service to advance the day
      await _databaseService.advanceUserToNextDay(user.value!.id!);
      
      // Update local day counter
      currentDay.value += 1;
      if (currentDay.value > 50) currentDay.value = 50; // Cap at 50
      
      // Refresh tasks for new day
      await loadTasks();
      
      // Show notification or message about new day
      Get.snackbar(
        'New Day',
        'You\'ve advanced to Day ${currentDay.value}!',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print("Error advancing to next day: $e");
    }
  }
  
  // Update the formatted time remaining string
  void _updateTimeRemaining(Duration timeRemaining) {
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    final seconds = timeRemaining.inSeconds % 60;
    
    formattedTimeRemaining.value = 
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Load tasks for the current day
  Future<void> loadTasks() async {
    if (user.value == null) return;
    
    try {
      isLoading.value = true;
      
      print("Loading tasks for day ${currentDay.value}");
      
      // Get tasks for the current day
      final dailyTasks = await _databaseService.getTasksForDay(currentDay.value);
      
      // Filter or modify tasks based on user's progress
      // This depends on how your app tracks completion
      final userCompletedTasks = await _databaseService.getUserCompletedTasks(user.value!.id!, currentDay.value);
      
      // Apply user-specific status to tasks
      for (var task in dailyTasks) {
        if (userCompletedTasks.contains(task.id)) {
          task.complete();
        }
      }
      
      tasks.value = dailyTasks;
      
      // Check for penalty missions
      hasPenaltyMissions.value = dailyTasks.any((task) => task.isPenalty);
      
      // Update user stats
      _updateUserStats();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load tasks: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Refresh tasks
  Future<void> refreshTasks() async {
    await loadTasks();
  }
  
  // Mark a task as completed by ID
  Future<void> markTaskCompleted(String taskId) async {
    final task = tasks.firstWhere((t) => t.id == taskId);
    await completeTask(task);
  }
  
  // Complete a task
  Future<void> completeTask(TaskModel task) async {
    if (user.value == null) return;
    
    try {
      isLoading.value = true;
      
      // Save the old level and class
      final oldLevel = user.value!.level;
      final oldClass = user.value!.playerClass;
      
      // Complete the task
      await _databaseService.completeTask(user.value!.id!, task, user.value!,);
      
      // Update local task
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        tasks.refresh();
      }
      
      // Update local user
      user.value = await _databaseService.getUser(user.value!.id!);
      
      // Update user stats
      _updateUserStats();
      
      // Check if all tasks are completed to advance to next day
      if (_canAdvanceToNextDay() && !hasPenaltyMissions.value) {
        Get.snackbar(
          'All Tasks Completed',
          'You\'ve completed all tasks for Day ${currentDay.value}!',
          snackPosition: SnackPosition.TOP,
        );
      }
      
      // Check if user leveled up
      if (user.value!.level > oldLevel) {
        Get.toNamed('/level-up', arguments: {
          'oldLevel': oldLevel,
          'newLevel': user.value!.level,
        });
        
        // _notificationService.showLevelUpNotification(user.value!.level);
      }
      
      // Check if user upgraded class
      if (user.value!.playerClass != oldClass) {
        Get.toNamed('/class_up', arguments: {
          'oldClass': oldClass,
          'newClass': user.value!.playerClass,
        });
        
        // _notificationService.showClassUpgradeNotification(user.value!.playerClass);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete task: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Check expired tasks and create penalties if needed
  Future<void> checkExpiredTasks() async {
    if (user.value == null) return;
    
    try {
      // Filter expired and pending tasks
      final expiredTasks = tasks
          .where((task) => 
              task.status == TaskStatus.pending && 
              task.isExpired())
          .toList();
      
      if (expiredTasks.isEmpty) return;
      
      // Mark tasks as failed
      for (final task in expiredTasks) {
        task.fail();
        await _databaseService.updateUserTaskStatus(user.value!.id!, task.id, TaskStatus.failed, currentDay.value);
        
        // Create a penalty task if it's not already a penalty
        if (!task.isPenalty) {
          await _databaseService.createPenaltyTask(user.value!.id!, task.category,);
          hasPenaltyMissions.value = true;
        } else {
          // If it's already a penalty and failed, mark user as dead
          await _databaseService.markUserAsDead(user.value!.id!);
          // await _notificationService.showDeathNotification();
          userDied.value = true;
          Get.offAllNamed('/death');
          return;
        }
      }
      
      // Refresh tasks
      await loadTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check expired tasks: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get the total count of all tasks
  int get totalTasksCount {
    return tasks.length;
  }

  // Get the count of completed tasks
  int get completedTasksCount {
    return tasks.where((task) => task.status == TaskStatus.completed).length;
  }
  
  // Filter tasks by category
  List<TaskModel> getTasksByCategory(TaskCategory category) {
    return tasks.where((task) => task.category == category).toList();
  }
  
  // Go to profile
  void goToProfile() {
    Get.toNamed('/profile');
  }
  
  // Go to store
  void goToStore() {
    Get.toNamed('/store');
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/login'); 
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}