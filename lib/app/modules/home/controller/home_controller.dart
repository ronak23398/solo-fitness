import 'package:get/get.dart';
import 'package:solo_fitness/app/data/services/database_service.dart';
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
  
  // New observable for low time warning
  RxBool showLowTimeWarning = false.obs;
  
  Timer? _timer;
  
  @override
  void onInit() {
    super.onInit();
    user.value = _authService.currentUser.value;
    
     if (user.value?.id != null) {
    _databaseService.taskService.setCurrentUser(user.value!.id!);
  }
    // Start with loading state
    isLoading.value = true;
    
    // Initialize states safely
    hasPenaltyMissions.value = false;
    userDied.value = false;
    showLowTimeWarning.value = false;
    
    // Use a single initialization flow
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      // First fetch the current day
      await _fetchUserCurrentDay();
      
      // Then start the timer
      _startDailyTimer();
      
      // Update user stats
      _updateUserStats();
      
      // Load tasks without checking for expired tasks
      await loadTasks();
      
      // Check if user already has penalty missions
      await _checkPenaltyStatus();
    } catch (e) {
      print("Error initializing user data: $e");
    } finally {
      // Only set loading to false when everything is complete
      isLoading.value = false;
    }
  }
  
  // New method to check if user already has penalty missions
  Future<void> _checkPenaltyStatus() async {
    if (user.value?.id == null) return;
    
    try {
      // Check for penalty tasks directly
      final penaltyTasks = await _databaseService.taskService.getPenaltyTasks();
      hasPenaltyMissions.value = penaltyTasks.isNotEmpty;
      
      // If there are penalty tasks, update the tasks list to include them
      if (hasPenaltyMissions.value) {
        // Add penalty tasks to the tasks list if they're not already there
        for (var task in penaltyTasks) {
          if (!tasks.any((t) => t.id == task.id)) {
            tasks.add(task);
          }
        }
        tasks.refresh();
      }
    } catch (e) {
      print("Error checking penalty status: $e");
    }
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
      final day = await _databaseService.taskService.getCurrentUserDay(user.value!.id!);
      currentDay.value = day;
      print("Current day for user ${user.value!.id}: ${currentDay.value}");
    } catch (e) {
      print("Error fetching current day: $e");
      // Default to day 1 if there's an error
      currentDay.value = 1;
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
      
      // Show warning if less than 4 hours remain and there are incomplete tasks
      if (timeUntilMidnight.inHours <= 4 && !_areAllTasksCompleted()) {
        showLowTimeWarning.value = true;
      } else {
        showLowTimeWarning.value = false;
      }
      
      // Check for expired tasks and reset day ONLY when timer reaches zero
      if (timeUntilMidnight.inSeconds <= 0) {
        _handleDayReset();
      }
    });
  }
  
  // Check if all non-penalty tasks are completed
  bool _areAllTasksCompleted() {
    final nonPenaltyTasks = tasks.where((task) => !task.isPenalty).toList();
    return nonPenaltyTasks.every((task) => task.status == TaskStatus.completed);
  }
  
  // Handle day reset at midnight
  void _handleDayReset() async {
  try {
    // First check for expired tasks before advancing day
    await checkExpiredTasks();
    
    // If no penalty missions were created, then we can advance the day
    if (!hasPenaltyMissions.value && _canAdvanceToNextDay()) {
      await _advanceToNextDay();
      
      // Update the currentDay value in user model too
      if (user.value != null) {
        user.value!.currentday = currentDay.value;
        await _databaseService.userService.updateUser(user.value!);
      }
    } else {
      // Otherwise just refresh tasks
      await loadTasks();
    }
    
    // Force refresh tasks regardless
    await loadTasks();
  } catch (e) {
    print("Error handling day reset: $e");
  }
}
  
  // Check if user can advance to next day
  bool _canAdvanceToNextDay() {
    // Logic to determine if user can advance
    // For example, if all non-penalty tasks are completed
    return _areAllTasksCompleted();
  }
  
  // Advance user to next day
  Future<void> _advanceToNextDay() async {
    if (user.value == null) return;
    
    try {
      // Call database service to advance the day
      await _databaseService.taskService.advanceUserToNextDay(user.value!.id!);
      
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
    print("Loading tasks for day ${currentDay.value}");
    
    // Get tasks for the current day
    final dailyTasks = await _databaseService.taskService.getTasksForDay(currentDay.value);
    
    // Get user-specific task completion data using the existing method
    final userCompletedTasks = await _databaseService.taskService.getUserCompletedTasks(
      user.value!.id!, 
      currentDay.value
    );
    
    // Apply user-specific status to tasks
    for (var task in dailyTasks) {
      if (userCompletedTasks.contains(task.id)) {
        task.complete();
      }
    }
    
    // Update tasks list 
    tasks.value = dailyTasks;
    
    // After loading tasks, check if we already have penalty missions
    await _checkPenaltyStatus();
    
  } catch (e) {
    print("Failed to load tasks: $e");
    Get.snackbar(
      'Error',
      'Failed to load tasks: $e',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
  
  // Refresh tasks
  Future<void> refreshTasks() async {
    // Set temporary loading indicator
    final wasLoading = isLoading.value;
    isLoading.value = true;
    
    try {
      await loadTasks();
    } catch (e) {
      print("Error refreshing tasks: $e");
    } finally {
      isLoading.value = wasLoading || false;
    }
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
      await _databaseService.taskService.completeTask(user.value!.id!, task, user.value!);
      
      // Update local task
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        tasks.refresh();
      }
      
      // Update local user
      user.value = await _databaseService.userService.getUser(user.value!.id!);
      
      // Update user stats
      _updateUserStats();
      
      // Check if task was a penalty task
      if (task.isPenalty) {
        // Recheck penalty status after completing a penalty task
        await _checkPenaltyStatus();
      }
      
      // Check if all tasks are completed to show message
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
  
  // Check expired tasks and create penalties if needed - now ONLY called at midnight
  Future<void> checkExpiredTasks() async {
    if (user.value == null) return;
    
    try {
      print("Checking for expired tasks at day reset");
      
      // Filter expired and pending tasks
      final expiredTasks = tasks
          .where((task) => 
              task.status == TaskStatus.pending && 
              !task.isPenalty) // Only check non-penalty tasks
          .toList();
      
      if (expiredTasks.isEmpty) {
        print("No expired tasks found");
        return;
      }
      
      print("Found ${expiredTasks.length} expired tasks");
      
      // Mark tasks as failed
      for (final task in expiredTasks) {
        task.fail();
        await _databaseService.taskService.updateUserTaskStatus(user.value!.id!, task.id, TaskStatus.failed, currentDay.value);
        
        // Create a penalty task
        await _databaseService.taskService.createPenaltyTask(user.value!.id!, task.category);
        print("Created penalty task for expired task: ${task.title}");
      }
      
      // Set penalty missions flag to true
      hasPenaltyMissions.value = true;
      
      // Check if there are existing penalty tasks that also expired
      final expiredPenaltyTasks = tasks
          .where((task) => 
              task.status == TaskStatus.pending && 
              task.isPenalty)
          .toList();
      
      if (expiredPenaltyTasks.isNotEmpty) {
        // If a penalty task expired, mark user as dead
        await _databaseService.userService.markUserAsDead(user.value!.id!);
        userDied.value = true;
        Get.offAllNamed('/death');
        return;
      }
      
      // Refresh tasks to include the new penalty tasks
      await loadTasks();
    } catch (e) {
      print("Error checking expired tasks: $e");
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