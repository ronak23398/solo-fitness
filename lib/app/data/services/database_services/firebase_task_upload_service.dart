import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:solo_fitness/app/data/models/task_model.dart';

/// Service for uploading tasks to Firebase
class FirebaseTaskUploadService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Random _random = Random();

  // Upload a batch of tasks to a specific day
  Future<void> uploadTasksForDay(int day, List<TaskModel> tasks) async {
    try {
      final dayRef = _database.ref().child('daily_tasks').child('day$day');
      
      // Create a map of tasks
      final Map<String, dynamic> tasksMap = {};
      for (var task in tasks) {
        tasksMap[task.id] = task.toMap();
      }
      
      // Set the tasks for this day
      await dayRef.child('tasks').set(tasksMap);
      
      print('Successfully uploaded ${tasks.length} tasks for day $day');
    } catch (e) {
      print('Error uploading tasks for day $day: $e');
      rethrow;
    }
  }

  // Generate random tasks for a specific day
  Future<void> generateAndUploadRandomTasks(int day, int count) async {
    try {
      List<TaskModel> tasks = [];
      
      // Categories to choose from
      final categories = [
        TaskCategory.strength,
        TaskCategory.endurance,
        TaskCategory.agility,
        TaskCategory.intelligence,
        TaskCategory.discipline,
      ];
      
      // Difficulties to choose from
      final difficulties = [
        TaskDifficulty.easy,
        TaskDifficulty.medium,
        TaskDifficulty.hard,
      ];
      
      // Generate random tasks
      for (int i = 0; i < count; i++) {
        final category = categories[_random.nextInt(categories.length)];
        final difficulty = difficulties[_random.nextInt(difficulties.length)];
        
        final task = TaskModel(
          id: 'task_${day}_$i',
          title: 'Task ${i + 1} for Day $day',
          description: 'This is a ${difficulty.toString().split('.').last} task for ${category.toString().split('.').last}',
          difficulty: difficulty,
          category: category,
          isPenalty: false,
        );
        
        tasks.add(task);
      }
      
      // Upload the generated tasks
      await uploadTasksForDay(day, tasks);
      
    } catch (e) {
      print('Error generating random tasks: $e');
      rethrow;
    }
  }
  
  // Upload a predefined set of tasks from external source
  Future<void> uploadPredefinedTasks(Map<int, List<TaskModel>> dayTasksMap) async {
    try {
      // For each day in the map, upload its tasks
      for (final entry in dayTasksMap.entries) {
        final day = entry.key;
        final tasks = entry.value;
        
        await uploadTasksForDay(day, tasks);
      }
      
      print('Successfully uploaded predefined tasks for ${dayTasksMap.length} days');
    } catch (e) {
      print('Error uploading predefined tasks: $e');
      rethrow;
    }
  }
}