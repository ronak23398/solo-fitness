// Updated method to upload tasks organized by day number
import 'package:firebase_database/firebase_database.dart';
import 'package:solo_fitness/app/data/models/task_model.dart';
import 'package:solo_fitness/app/data/services/uploaddt.dart';

// Future<void> uploadToFirebaseRealtimeDB() async {
//   print("upload to firebase started");
//   try {
//     // Get all 50 days of tasks
//     List<DailyTasks> allDays = TaskProgram().createFiftyDayProgram();
    
//     // Get reference to the database
//     final DatabaseReference database = FirebaseDatabase.instance.ref();
    
//     // Create a reference to the daily_tasks node
//     final DatabaseReference tasksRef = database.child('daily_tasks');
    
//     // Use transactions or batched updates for better performance and reliability
//     for (var dayTasks in allDays) {
//       // Create a reference for this specific day
//       final dayRef = tasksRef.child('day${dayTasks.dayNumber}');
      
//       // Create the day data
//       Map<String, dynamic> dayData = {
//         'dayNumber': dayTasks.dayNumber,
//         'taskCount': dayTasks.tasks.length,
//         'createdAt': ServerValue.timestamp,
//       };
      
//       // Update day metadata
//       await dayRef.update(dayData);
      
//       // Add each task under this day's tasks node
//       for (var task in dayTasks.tasks) {
//         await dayRef.child('tasks').child(task.id).set({
//           'id': task.id,
//           'title': task.title,
//           'description': task.description,
//           'difficulty': task.difficulty.toString().split('.').last,
//           'category': task.category.toString().split('.').last,
//           'status': 'pending',
//           'isPenalty': false,
//           'createdAt': ServerValue.timestamp,
//           'expiresAt': ServerValue.timestamp, // You might want to calculate a proper expiration
//           'statPoints': _calculateDefaultStatPoints(task.difficulty.toString().split('.').last),
//           'xpPoints': _calculateDefaultXpPoints(task.difficulty.toString().split('.').last),
//         });
//       }
      
//       print('Uploaded day ${dayTasks.dayNumber}');
      
//       // To avoid making too many requests at once, add a small delay every 10 days
//       if (dayTasks.dayNumber % 10 == 0) {
//         await Future.delayed(Duration(milliseconds: 500));
//       }
//     }
    
//     print('Successfully uploaded 50 days of tasks to Firebase Realtime Database');
//   } catch (e) {
//     print('Error uploading tasks to Firebase Realtime Database: $e');
//     throw e;
//   }
// }

// // Helper functions for calculating default point values
// int _calculateDefaultStatPoints(String difficulty) {
//   switch (difficulty.toLowerCase()) {
//     case 'easy':
//       return 5;
//     case 'medium':
//       return 10;
//     case 'hard':
//       return 15;
//     default:
//       return 5;
//   }
// }

// int _calculateDefaultXpPoints(String difficulty) {
//   switch (difficulty.toLowerCase()) {
//     case 'easy':
//       return 10;
//     case 'medium':
//       return 20;
//     case 'hard':
//       return 30;
//     default:
//       return 10;
//   }
// }

// // Updated method to get tasks for a specific day
// Future<List<TaskModel>> getTasksForDay(int dayNumber) async {
//   print("getTasksForDay called for day: $dayNumber");
  
//   try {
//     // Get reference to the daily_tasks node for this specific day
//     final databaseReference = FirebaseDatabase.instance.ref();
//     final dayRef = databaseReference.child('daily_tasks').child('day$dayNumber');
    
//     print("Attempting to fetch data at path: ${dayRef.path}");
    
//     // Get the snapshot
//     final DataSnapshot snapshot = await dayRef.once().then((event) => event.snapshot);
    
//     print("Snapshot exists: ${snapshot.exists}");
    
//     if (!snapshot.exists) {
//       print("No tasks found for day $dayNumber");
//       return [];
//     }
    
//     // Check if tasks exist in the snapshot
//     Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
//     if (data == null) {
//       print("Data is null for day $dayNumber");
//       return [];
//     }
    
//     // Get tasks from the snapshot
//     Map<dynamic, dynamic>? tasksData = data['tasks'] as Map<dynamic, dynamic>?;
//     if (tasksData == null) {
//       print("No tasks found for day $dayNumber");
//       return [];
//     }
    
//     print("Number of tasks found: ${tasksData.length}");
    
//     // Convert to TaskModel objects
//     List<TaskModel> tasksList = [];
//     tasksData.forEach((key, value) {
//       print("Processing task with key: $key");
//       try {
//         final taskData = value as Map<dynamic, dynamic>;
        
//         // Convert dynamic map to string map
//         Map<String, dynamic> stringTaskData = {};
//         taskData.forEach((k, v) {
//           stringTaskData[k.toString()] = v;
//         });
        
//         // Add the ID to the data
//         stringTaskData['id'] = key.toString();
        
//         TaskModel task = TaskModel.fromMap(stringTaskData);
//         tasksList.add(task);
//         print("Successfully converted to TaskModel: ${task.title}");
//       } catch (e, stackTrace) {
//         print("Error parsing task with key $key: $e");
//         print("Stack trace: $stackTrace");
//       }
//     });
    
//     print("Returning ${tasksList.length} tasks for day $dayNumber");
//     return tasksList;
//   } catch (e, stackTrace) {
//     print("Error in getTasksForDay: $e");
//     print("Stack trace: $stackTrace");
//     return []; // Return empty list instead of rethrowing to prevent app crashes
//   }
// }

// // Helper function to get the current user's progress day
// Future<int> getCurrentUserDay(String userId) async {
//   try {
//     // This could read from a user profile or progress document
//     final userRef = FirebaseDatabase.instance.ref().child('users').child(userId);
//     final snapshot = await userRef.child('currentDay').once().then((event) => event.snapshot);
    
//     if (snapshot.exists && snapshot.value != null) {
//       return int.parse(snapshot.value.toString());
//     }
    
//     // Default to day 1 if no progress is found
//     return 1;
//   } catch (e) {
//     print("Error getting current user day: $e");
//     return 1; // Default to day 1 on error
//   }
// }

// // Convenience method to get the current day's tasks for a user
// Future<List<TaskModel>> getCurrentDayTasks(String userId) async {
//   final currentDay = await getCurrentUserDay(userId);
//   return getTasksForDay(currentDay);
// }

// // Method to update user progress to the next day
// Future<void> advanceUserToNextDay(String userId) async {
//   try {
//     final userRef = FirebaseDatabase.instance.ref().child('users').child(userId);
//     final snapshot = await userRef.child('currentDay').once().then((event) => event.snapshot);
    
//     int currentDay = 1;
//     if (snapshot.exists && snapshot.value != null) {
//       currentDay = int.parse(snapshot.value.toString());
//     }
    
//     // Move to next day, cap at 50
//     int nextDay = currentDay + 1;
//     if (nextDay > 50) nextDay = 50;
    
//     // Update user's current day
//     await userRef.update({
//       'currentDay': nextDay,
//       'lastUpdated': ServerValue.timestamp
//     });
    
//     print("Advanced user $userId to day $nextDay");
//   } catch (e) {
//     print("Error advancing user day: $e");
//     throw e;
//   }
// }