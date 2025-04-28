import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/database_service.dart';

class PenaltyController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  // final NotificationService _notificationService = Get.find<NotificationService>();
  
  final RxList<TaskModel> penaltyTasks = <TaskModel>[].obs;
  final RxBool isLoading = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadPenaltyTasks();
  }
  
  Future<void> _loadPenaltyTasks() async {
    try {
      isLoading.value = true;
      penaltyTasks.value = await _databaseService.getPenaltyTasks();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load penalty tasks: ${e.toString()}');
    }
  }
  
  Future<void> markPenaltyTaskCompleted(String taskId) async {
    try {
      await _databaseService.markTaskCompleted(taskId);
      // Update the task in the list
      int index = penaltyTasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        // Use the complete() method instead of copyWith
        penaltyTasks[index].complete();
        penaltyTasks.refresh(); // Refresh to update UI
        
        // Apply rewards
        await _databaseService.addUserStats(
          penaltyTasks[index].category,
          penaltyTasks[index].statPoints,
        );
        await _databaseService.addUserXP(penaltyTasks[index].xpPoints);
        
        Get.snackbar(
          'Success',
          'You have completed a penalty task and earned ${penaltyTasks[index].statPoints} ${_getCategoryString(penaltyTasks[index].category)} points and ${penaltyTasks[index].xpPoints} XP!'
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete task: ${e.toString()}');
    }
  }
  
  String _getCategoryString(TaskCategory category) {
    switch (category) {
      case TaskCategory.strength:
        return 'Strength';
      case TaskCategory.endurance:
        return 'Endurance';
      case TaskCategory.agility:
        return 'Agility';
      case TaskCategory.intelligence:
        return 'Intelligence';
      case TaskCategory.discipline:
        return 'Discipline';
      default:
        return 'Unknown';
    }
  }
  
  Future<void> checkPenaltyTasksStatus() async {
    // Check if all penalty tasks are completed
    bool allCompleted = penaltyTasks.every((task) => task.status == TaskStatus.completed);
    
    if (!allCompleted && penaltyTasks.isNotEmpty && 
        DateTime.now().isAfter(penaltyTasks[0].expiresAt)) {
      // User has failed penalty tasks - trigger death
      await _databaseService.setUserDied(true);
      // _notificationService.showDeathNotification();
      Get.offAllNamed('/death');
    }
  }
  
  Future<void> refreshPenaltyTasks() async {
    await _loadPenaltyTasks();
  }
}