import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/services/firebasetasksupload.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/streak_model.dart';
import '../models/store_model.dart';

class DatabaseService extends GetxService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Uuid _uuid = Uuid();
  String? _currentUserUid;

  void setCurrentUser(String uid) {
    _currentUserUid = uid;
  }

  // Users Collection
  Future<void> createUser(UserModel user) async {
    try {
      String? userId = user.id;
      if (userId!.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      // Create user in the users node
      await _database.ref().child('users').child(userId).set(user.toMap());

      // Also create a streak model for the user
      final streak = StreakModel();
      await _database.ref().child('streaks').child(userId).set(streak.toMap());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final snapshot = await _database.ref().child('users').child(userId).get();
      if (snapshot.exists && snapshot.value != null) {
        return UserModel.fromMap(
          Map<String, dynamic>.from(snapshot.value as Map),
        );
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      String? userId = user.id;
      if (userId!.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      await _database.ref().child('users').child(userId).update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
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

  Future<void> completeTask(
    String userId,
    TaskModel task,
    UserModel user,
  ) async {
    try {
      // Mark task as completed
      task.complete();

      // Update task
      await _database
          .ref()
          .child('tasks')
          .child(userId)
          .child(task.id)
          .update(task.toMap());

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

  // Mark user as dead
  Future<void> markUserAsDead(String userId) async {
    try {
      await _database.ref().child('users').child(userId).update({
        'isDead': true,
      });
    } catch (e) {
      print('Error marking user as dead: $e');
      rethrow;
    }
  }

  // Store Products
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _database.ref().child('products').get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final productsMap = snapshot.value as Map;
      return productsMap.entries
          .map(
            (entry) => ProductModel.fromMap(
              Map<String, dynamic>.from(entry.value as Map),
            ),
          )
          .toList();
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(
    ProductCategory category,
  ) async {
    try {
      final categoryValue = category.toString().split('.').last;
      final snapshot =
          await _database
              .ref()
              .child('products')
              .orderByChild('category')
              .equalTo(categoryValue)
              .get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final productsMap = snapshot.value as Map;
      return productsMap.entries
          .map(
            (entry) => ProductModel.fromMap(
              Map<String, dynamic>.from(entry.value as Map),
            ),
          )
          .toList();
    } catch (e) {
      print('Error getting products by category: $e');
      rethrow;
    }
  }

  // Orders
  Future<void> createOrder(OrderModel order) async {
    try {
      // Generate a unique ID if not provided
      String orderId = order.id;
      if (orderId.isEmpty) {
        orderId = _uuid.v4();
        order = OrderModel(
          id: orderId,
          userId: order.userId,
          items: order.items,
          totalAmount: order.totalAmount,
          deliveryAddress: order.deliveryAddress,
          contactNumber: order.contactNumber,
        );
      }

      await _database.ref().child('orders').child(orderId).set(order.toMap());

      // Also add reference to user's orders for easy querying
      await _database
          .ref()
          .child('user_orders')
          .child(order.userId)
          .child(orderId)
          .set(true);
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      // First get the order IDs for this user
      final userOrdersSnapshot =
          await _database.ref().child('user_orders').child(userId).get();

      if (!userOrdersSnapshot.exists || userOrdersSnapshot.value == null) {
        return [];
      }

      // Get the actual order details
      final orderIdsMap = userOrdersSnapshot.value as Map;
      final List<OrderModel> orders = [];

      for (var orderId in orderIdsMap.keys) {
        final orderSnapshot =
            await _database
                .ref()
                .child('orders')
                .child(orderId.toString())
                .get();

        if (orderSnapshot.exists && orderSnapshot.value != null) {
          orders.add(
            OrderModel.fromMap(
              Map<String, dynamic>.from(orderSnapshot.value as Map),
            ),
          );
        }
      }

      // Sort by order date descending
      orders.sort((a, b) => b.orderDate!.compareTo(a.orderDate));

      return orders;
    } catch (e) {
      print('Error getting user orders: $e');
      rethrow;
    }
  }

  // Get user streak data from Firebase Realtime Database
  Future<StreakModel?> getUserStreak() async {
    try {
      final DatabaseReference streakRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(UserModel().id!)
          .child('streak');

      DatabaseEvent event = await streakRef.once();

      if (event.snapshot.value == null) {
        // Return a new streak model if the user doesn't have one yet
        return StreakModel();
      }

      Map<String, dynamic> streakMap = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>,
      );

      return StreakModel.fromMap(streakMap);
    } catch (e) {
      print('Error getting user streak: $e');
      return null;
    }
  }

  // Add XP to user
  Future<void> addUserXP(int xpAmount) async {
    try {
      final DatabaseReference userXpRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('xp');

      // Get current XP
      DatabaseEvent event = await userXpRef.once();
      int currentXp = 0;

      if (event.snapshot.value != null) {
        currentXp = (event.snapshot.value as int);
      }

      // Update with new XP
      await userXpRef.set(currentXp + xpAmount);
    } catch (e) {
      print('Error adding user XP: $e');
      throw Exception('Failed to add XP: $e');
    }
  }

  // Add bonus task to user tasks
  Future<void> addBonusTask() async {
    try {
      final DatabaseReference tasksRef = FirebaseDatabase.instance
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

  // Add a title to user profile
  Future<void> addUserTitle(String title) async {
    try {
      final DatabaseReference titlesRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('titles');

      // First get existing titles
      DatabaseEvent event = await titlesRef.once();
      List<String> titles = [];

      if (event.snapshot.value != null) {
        List<dynamic> existingTitles = event.snapshot.value as List<dynamic>;
        titles = existingTitles.cast<String>();
      }

      // Add new title if not already there
      if (!titles.contains(title)) {
        titles.add(title);
      }

      // Save updated titles list
      await titlesRef.set(titles);

      // Also set as active title
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('activeTitle')
          .set(title);
    } catch (e) {
      print('Error adding user title: $e');
      throw Exception('Failed to add title: $e');
    }
  }

  // Mark streak reward as claimed
  Future<void> markStreakRewardClaimed(int streakDay) async {
    try {
      // Get current streak data
      StreakModel? streak = await getUserStreak();
      if (streak == null) {
        throw Exception('Failed to get streak data');
      }

      // Update the appropriate reward based on streak day
      String rewardKey;
      if (streakDay == 3) {
        rewardKey = 'day3';
      } else if (streakDay == 7) {
        rewardKey = 'day7';
      } else if (streakDay == 30) {
        rewardKey = 'day30';
      } else {
        throw Exception('Invalid streak day: $streakDay');
      }

      // Mark reward as claimed
      streak.rewards[rewardKey] = true;

      // Update streak in database
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('streak')
          .set(streak.toMap());
    } catch (e) {
      print('Error marking streak reward claimed: $e');
      throw Exception('Failed to mark streak reward as claimed: $e');
    }
  }

  Future<void> updateStreak(String userId, StreakModel streak) async {
    try {
      await _database
          .ref()
          .child('streaks')
          .child(userId)
          .update(streak.toMap());
    } catch (e) {
      print('Error updating streak: $e');
      rethrow;
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

  // Add these methods to your DatabaseService class

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
          // If stored as a map with keys, extract values
          return Map<String, dynamic>.from(
            snapshot.value as Map,
          ).values.map((e) => e.toString()).toList();
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

  // Add stat points to user's stats
  Future<void> addUserStats(TaskCategory category, int points) async {
    if (_currentUserUid == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Get the category name for the database path
      String categoryName = category.toString().split('.').last;

      // Get current stat value
      DatabaseReference statRef = _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('stats')
          .child(categoryName);

      final snapshot = await statRef.get();
      int currentValue = 0;

      if (snapshot.exists && snapshot.value != null) {
        currentValue = int.parse(snapshot.value.toString());
      }

      // Update with new value
      await statRef.set(currentValue + points);
    } catch (e) {
      throw Exception('Failed to add user stats: ${e.toString()}');
    }
  }

  // Set user died status
  Future<void> setUserDied(bool died) async {
    if (_currentUserUid == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('died')
          .set(died);

      if (died) {
        // Record death timestamp
        await _database
            .ref()
            .child('users')
            .child(_currentUserUid!)
            .child('diedAt')
            .set(DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      throw Exception('Failed to set user died status: ${e.toString()}');
    }
  }

  // Revive user with Black Heart
  Future<void> reviveUser() async {
    if (_currentUserUid == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Reset died status
      await _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('died')
          .set(false);

      // Reset any penalty tasks
      await _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('penaltyTasks')
          .remove();

      // Record revival timestamp
      await _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('revivedAt')
          .set(DateTime.now().millisecondsSinceEpoch);

      // Decrement Black Hearts
      DatabaseReference heartsRef = _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('blackHearts');

      final snapshot = await heartsRef.get();
      int hearts = 0;

      if (snapshot.exists && snapshot.value != null) {
        hearts = int.parse(snapshot.value.toString());
      }

      if (hearts > 0) {
        await heartsRef.set(hearts - 1);
      } else {
        throw Exception('No Black Hearts available');
      }
    } catch (e) {
      throw Exception('Failed to revive user: ${e.toString()}');
    }
  }

  // Updated method to get tasks for a specific day
  Future<List<TaskModel>> getTasksForDay(int dayNumber) async {
    print("getTasksForDay called for day: $dayNumber");

    try {
      // Get reference to the daily_tasks node for this specific day
      final databaseReference = FirebaseDatabase.instance.ref();
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
      final userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId);
      final snapshot = await userRef
          .child('currentDay')
          .once()
          .then((event) => event.snapshot);

      int currentDay = 1;
      if (snapshot.exists && snapshot.value != null) {
        currentDay = int.parse(snapshot.value.toString());
      }

      // Move to next day, cap at 50
      int nextDay = currentDay + 1;
      if (nextDay > 50) nextDay = 50;

      // Update user's current day
      await userRef.update({
        'currentDay': nextDay,
        'lastUpdated': ServerValue.timestamp,
      });

      print("Advanced user $userId to day $nextDay");
    } catch (e) {
      print("Error advancing user day: $e");
      throw e;
    }
  }
    //

    // Reset user (if they choose not to use Black Heart)
    Future<void> resetUser() async {
      if (_currentUserUid == null) {
        throw Exception('User not authenticated');
      }

      try {
        // Keep user auth but reset progress
        await _database.ref().child('users').child(_currentUserUid!).update({
          'level': 1,
          'xp': 0,
          'classRank': 'E',
          'died': false,
          'diedAt': null,
          'revivedAt': null,
          'streak': 0,
          'lastLogin': DateTime.now().millisecondsSinceEpoch,
          'stats': {
            'strength': 0,
            'endurance': 0,
            'agility': 0,
            'intelligence': 0,
            'discipline': 0,
          },
        });

        // Clear tasks and penalty tasks
        await _database
            .ref()
            .child('users')
            .child(_currentUserUid!)
            .child('tasks')
            .remove();

        await _database
            .ref()
            .child('users')
            .child(_currentUserUid!)
            .child('penaltyTasks')
            .remove();

        // Generate new daily tasks
        await getCurrentUserDay;
      } catch (e) {
        throw Exception('Failed to reset user: ${e.toString()}');
      }
    }

    Future<List<ProductModel>> getStoreItems() async {
      try {
        // Get reference to the products node in the database
        final DatabaseReference productsRef = FirebaseDatabase.instance
            .ref()
            .child('products');

        // Get snapshot of the products
        DatabaseEvent event = await productsRef.once();

        // Check if data exists
        if (event.snapshot.value == null) {
          return [];
        }

        // Convert snapshot to List of ProductModel objects
        List<ProductModel> products = [];
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, value) {
          Map<String, dynamic> productMap = Map<String, dynamic>.from(value);

          // Make sure the id is set from the key if not in the data
          if (productMap['id'] == null) {
            productMap['id'] = key;
          }

          products.add(ProductModel.fromMap(productMap));
        });

        return products;
      } catch (e) {
        print('Error getting store items: $e');
        return [];
      }
    }

    // Helper function to get the current user's progress day
    Future<int> getCurrentUserDay(String userId) async {
      try {
        // This could read from a user profile or progress document
        final userRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId);
        final snapshot = await userRef
            .child('currentDay')
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

