import 'package:firebase_database/firebase_database.dart';
import 'package:solo_fitness/app/data/models/streak_model.dart';
import 'package:solo_fitness/app/data/models/task_model.dart';
import 'package:solo_fitness/app/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

/// Service for task-related operations
class TaskService {
  final FirebaseDatabase _database;
  final Uuid _uuid;
  String? _currentUserUid;

  TaskService(this._database, this._uuid);

  void setCurrentUser(String uid) {
    _currentUserUid = uid;
  }

  Future<void> addTask(String userId, TaskModel task) async {
    try {
      // Generate a unique ID if not provided
      String taskId = task.id;
      if (taskId.isEmpty) {
        taskId = _uuid.v4();
        task = TaskModel(
          id: taskId,
          title: task.title,
          description: task.description,
          difficulty: task.difficulty,
          category: task.category,
          isPenalty: task.isPenalty,
        );
      }

      await _database
          .ref()
          .child('tasks')
          .child(userId)
          .child(taskId)
          .set(task.toMap());
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(String userId, TaskModel task) async {
    try {
      String taskId = task.id;
      if (taskId.isEmpty) {
        throw Exception('Task ID cannot be empty');
      }

      await _database
          .ref()
          .child('tasks')
          .child(userId)
          .child(taskId)
          .update(task.toMap());
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _database.ref().child('tasks').child(userId).child(taskId).remove();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  Future<void> completeTask(String userId, TaskModel task, UserModel user) async {
  try {
    // Mark task as completed
    task.complete();

    // 1. Update task in the tasks node
    await _database
        .ref()
        .child('tasks')
        .child(userId)
        .child(task.id)
        .update(task.toMap());

    // 2. ALSO store in userProgress for the specific day for persistence
    await _database
        .ref()
        .child('userProgress')
        .child(userId)
        .child('day_${user.currentday}')  // note the lowercase 'd'
        .child('completedTasks')
        .child(task.id)
        .set(true);  // using task.id as key for faster lookups


      // Update user stats and XP
      user.xp += task.xpPoints;
      String categoryKey =
          task.category.toString().split('.').last.toLowerCase();
      user.stats[categoryKey] =
          (user.stats[categoryKey] ?? 0) + task.statPoints;

      // Check if user should level up
      if (user.shouldLevelUp()) {
        user.levelUp();
      }

      // Update user document
      await _database.ref().child('users').child(userId).update(user.toMap());

      // Update streak
      final streakSnapshot =
          await _database.ref().child('streaks').child(userId).get();

      if (streakSnapshot.exists && streakSnapshot.value != null) {
        final streak = StreakModel.fromMap(
          Map<String, dynamic>.from(streakSnapshot.value as Map),
        );
        streak.updateStreak();
        await _database
            .ref()
            .child('streaks')
            .child(userId)
            .update(streak.toMap());
      }
    } catch (e) {
      print('Error completing task: $e');
      rethrow;
    }
  }

  // Create penalty task
  Future<void> createPenaltyTask(String userId, TaskCategory category) async {
    try {
      final penaltyTask = TaskModel(
        id: _uuid.v4(),
        title: 'Penalty Mission',
        description:
            'You failed your previous task. Complete this harder task or face death!',
        difficulty: TaskDifficulty.extreme,
        category: category,
        isPenalty: true,
      );

      await addTask(userId, penaltyTask);
    } catch (e) {
      print('Error creating penalty task: $e');
      rethrow;
    }
  }

  // Add bonus task to user tasks
  Future<void> addBonusTask() async {
    try {
      if (_currentUserUid == null) {
        throw Exception('User not authenticated');
      }

      final DatabaseReference tasksRef = _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('tasks');

      // Create a new task with unique ID
      String taskId = DateTime.now().millisecondsSinceEpoch.toString();

      Map<String, dynamic> bonusTask = {
        'id': taskId,
        'title': 'Streak Bonus Challenge',
        'description': 'Complete this special challenge to earn extra rewards!',
        'xpReward': 150,
        'isBonus': true,
        'isCompleted': false,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'difficulty': 'medium',
      };

      await tasksRef.child(taskId).set(bonusTask);
    } catch (e) {
      print('Error adding bonus task: $e');
      throw Exception('Failed to add bonus task: $e');
    }
  }

 Future<List<String>> getUserCompletedTasks(String userId, int day) async {
  try {
    final snapshot =
        await _database
            .ref()
            .child('userProgress')
            .child(userId)
            .child('day_$day')
            .child('completedTasks')
            .get();

    if (snapshot.exists && snapshot.value != null) {
      // Convert the snapshot value to a List<String>
      if (snapshot.value is List) {
        return List<String>.from(snapshot.value as List);
      } else if (snapshot.value is Map) {
        // For Firebase Realtime Database, we need to extract KEYS
        // because your structure stores task IDs as keys with 'true' values
        return Map<dynamic, dynamic>.from(
          snapshot.value as Map,
        ).keys.map((e) => e.toString()).toList();
      }
    }
    return [];
  } catch (e) {
    print('Error getting completed tasks: $e');
    return [];
  }
}

  Future<void> updateUserTaskStatus(
    String userId,
    String taskId,
    TaskStatus status,
    int day,
  ) async {
    try {
      // Update the task status in the tasks node
      await _database.ref().child('tasks').child(userId).child(taskId).update({
        'status': status.toString().split('.').last,
      });

      // If task is completed, also add to the user's completed tasks for the day
      if (status == TaskStatus.completed) {
        await _database
            .ref()
            .child('userProgress')
            .child(userId)
            .child('day_$day')
            .child('completedTasks')
            .push()
            .set(taskId);
      }

      // If task is failed, update the user's failed tasks
      if (status == TaskStatus.failed) {
        await _database
            .ref()
            .child('userProgress')
            .child(userId)
            .child('day_$day')
            .child('failedTasks')
            .push()
            .set(taskId);
      }
    } catch (e) {
      print('Error updating task status: $e');
      rethrow;
    }
  }

  // Mark a task as completed
  Future<void> markTaskCompleted(String taskId) async {
    if (_currentUserUid == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Update the task status to completed
      await _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('tasks')
          .child(taskId)
          .update({
            'status': TaskStatus.completed.toString().split('.').last,
            'completedAt': DateTime.now().millisecondsSinceEpoch,
          });

      // Also check if it's a penalty task and update there
      await _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('penaltyTasks')
          .child(taskId)
          .update({
            'status': TaskStatus.completed.toString().split('.').last,
            'completedAt': DateTime.now().millisecondsSinceEpoch,
          });
    } catch (e) {
      throw Exception('Failed to mark task as completed: ${e.toString()}');
    }
  }

  // Get penalty tasks for the current user
  Future<List<TaskModel>> getPenaltyTasks() async {
    if (_currentUserUid == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Reference to the penalty tasks for the current user
      DatabaseReference ref = _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('penaltyTasks');

      final snapshot = await ref.get();

      if (snapshot.exists) {
        List<TaskModel> tasks = [];
        Map<dynamic, dynamic> tasksMap =
            snapshot.value as Map<dynamic, dynamic>;

        tasksMap.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> taskMap = Map<String, dynamic>.from(value);
            taskMap['id'] = key;
            tasks.add(TaskModel.fromMap(taskMap));
          }
        });

        // Sort by expiration date
        tasks.sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
        return tasks;
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load penalty tasks: ${e.toString()}');
    }
  }

  // Updated method to get tasks for a specific day
  Future<List<TaskModel>> getTasksForDay(int dayNumber) async {
    print("getTasksForDay called for day: $dayNumber");

    try {
      // Get reference to the daily_tasks node for this specific day
      final databaseReference = _database.ref();
      final dayRef = databaseReference
          .child('daily_tasks')
          .child('day$dayNumber');

      print("Attempting to fetch data at path: ${dayRef.path}");

      // Get the snapshot
      final DataSnapshot snapshot = await dayRef.once().then(
        (event) => event.snapshot,
      );

      print("Snapshot exists: ${snapshot.exists}");

      if (!snapshot.exists) {
        print("No tasks found for day $dayNumber");
        return [];
      }

      // Check if tasks exist in the snapshot
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        print("Data is null for day $dayNumber");
        return [];
      }

      // Get tasks from the snapshot
      Map<dynamic, dynamic>? tasksData =
          data['tasks'] as Map<dynamic, dynamic>?;
      if (tasksData == null) {
        print("No tasks found for day $dayNumber");
        return [];
      }

      print("Number of tasks found: ${tasksData.length}");

      // Convert to TaskModel objects
      List<TaskModel> tasksList = [];
      tasksData.forEach((key, value) {
        print("Processing task with key: $key");
        try {
          final taskData = value as Map<dynamic, dynamic>;

          // Convert dynamic map to string map
          Map<String, dynamic> stringTaskData = {};
          taskData.forEach((k, v) {
            stringTaskData[k.toString()] = v;
          });

          // Add the ID to the data
          stringTaskData['id'] = key.toString();

          TaskModel task = TaskModel.fromMap(stringTaskData);
          tasksList.add(task);
          print("Successfully converted to TaskModel: ${task.title}");
        } catch (e, stackTrace) {
          print("Error parsing task with key $key: $e");
          print("Stack trace: $stackTrace");
        }
      });

      print("Returning ${tasksList.length} tasks for day $dayNumber");
      return tasksList;
    } catch (e, stackTrace) {
      print("Error in getTasksForDay: $e");
      print("Stack trace: $stackTrace");
      return []; // Return empty list instead of rethrowing to prevent app crashes
    }
  }

  // Method to update user progress to the next day
Future<void> advanceUserToNextDay(String userId) async {
  try {
    final userRef = _database.ref().child('users').child(userId);
    
    // Get the current day field name used in your database
    // IMPORTANT: Use consistent capitalization for the field
    final String dayFieldName = 'currentday'; // Use lowercase 'd' consistently
    
    final snapshot = await userRef
        .child(dayFieldName)
        .once()
        .then((event) => event.snapshot);

    int currentDay = 1;
    if (snapshot.exists && snapshot.value != null) {
      currentDay = int.parse(snapshot.value.toString());
    }

    // Move to next day, cap at 50
    int nextDay = currentDay + 1;
    if (nextDay > 50) nextDay = 50;

    // Update user's current day using the SAME field name
    await userRef.update({
      dayFieldName: nextDay,
      'lastUpdated': ServerValue.timestamp,
    });

    print("Advanced user $userId to day $nextDay");
  } catch (e) {
    print("Error advancing user day: $e");
    throw e;
  }
}

  // Helper function to get the current user's progress day
  Future<int> getCurrentUserDay(String userId) async {
    try {
      // This could read from a user profile or progress document
      final userRef = _database.ref().child('users').child(userId);
      final snapshot = await userRef
          .child('currentday') // lowercase 'd' to match your database field
          .once()
          .then((event) => event.snapshot);

      if (snapshot.exists && snapshot.value != null) {
        return int.parse(snapshot.value.toString());
      }

      // Default to day 1 if no progress is found
      return 1;
    } catch (e) {
      print("Error getting current user day: $e");
      return 1; // Default to day 1 on error
    }
  }

  // Convenience method to get the current day's tasks for a user
  Future<List<TaskModel>> getCurrentDayTasks(String userId) async {
    final currentDay = await getCurrentUserDay(userId);
    return getTasksForDay(currentDay);
  }
}
