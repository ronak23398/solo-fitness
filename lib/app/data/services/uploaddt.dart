// import 'package:solo_fitness/app/data/models/task_model.dart';
// import 'package:uuid/uuid.dart';

// // Assuming these enums are already defined elsewhere in your code
// // enum TaskDifficulty { easy, medium, hard }
// // enum TaskCategory { strength, endurance, agility, intelligence, discipline }

// class DailyTasks {
//   final String id;
//   final int dayNumber;
//   final List<TaskModel> tasks;

//   DailyTasks({
//     required this.id,
//     required this.dayNumber,
//     required this.tasks,
//   });
// }

// class TaskProgram {
//   final Uuid _uuid = Uuid();
  
//   // Method to create all 50 days of tasks
//   List<DailyTasks> createFiftyDayProgram() {
//     List<DailyTasks> allDays = [];
    
//     for (int day = 1; day <= 50; day++) {
//       // Calculate difficulty distribution based on progression
//       // Early days have more easy tasks, later days have more hard tasks
//       int tasksPerDay = 5 + (day % 4); // Alternates between 5-8 tasks
      
//       int easyCount, mediumCount, hardCount;
      
//       if (day <= 15) { // First third - mostly easy
//         easyCount = (tasksPerDay * 0.5).ceil();
//         mediumCount = (tasksPerDay * 0.4).ceil();
//         hardCount = tasksPerDay - easyCount - mediumCount;
//       } else if (day <= 35) { // Middle - more medium
//         easyCount = (tasksPerDay * 0.3).ceil();
//         mediumCount = (tasksPerDay * 0.5).ceil();
//         hardCount = tasksPerDay - easyCount - mediumCount;
//       } else { // Last third - more hard
//         easyCount = (tasksPerDay * 0.2).ceil();
//         mediumCount = (tasksPerDay * 0.4).ceil();
//         hardCount = tasksPerDay - easyCount - mediumCount;
//       }
      
//       List<TaskModel> dayTasks = _createTasksForDay(
//         day, 
//         easyCount, 
//         mediumCount, 
//         hardCount
//       );
      
//       allDays.add(DailyTasks(
//         id: _uuid.v4(),
//         dayNumber: day,
//         tasks: dayTasks,
//       ));
//     }
    
//     return allDays;
//   }
  
//   // Helper method to create tasks for a specific day
//   List<TaskModel> _createTasksForDay(int day, int easyCount, int mediumCount, int hardCount) {
//     List<TaskModel> tasks = [];
    
//     // We'll use these lists to pick tasks based on difficulty
//     List<TaskModel> easyTasks = _getTasksByDifficulty(TaskDifficulty.easy, day);
//     List<TaskModel> mediumTasks = _getTasksByDifficulty(TaskDifficulty.medium, day);
//     List<TaskModel> hardTasks = _getTasksByDifficulty(TaskDifficulty.hard, day);
    
//     // Add tasks of each difficulty
//     for (int i = 0; i < easyCount; i++) {
//       if (easyTasks.isNotEmpty) {
//         tasks.add(easyTasks.removeAt(0)); // Take and remove first task
//       }
//     }
    
//     for (int i = 0; i < mediumCount; i++) {
//       if (mediumTasks.isNotEmpty) {
//         tasks.add(mediumTasks.removeAt(0));
//       }
//     }
    
//     for (int i = 0; i < hardCount; i++) {
//       if (hardTasks.isNotEmpty) {
//         tasks.add(hardTasks.removeAt(0));
//       }
//     }
    
//     return tasks;
//   }
  
//   // Get tasks based on difficulty and day (for progression)
//   List<TaskModel> _getTasksByDifficulty(TaskDifficulty difficulty, int day) {
//     // Multiplier for progression - tasks get harder as days increase
//     double progressMultiplier = 1.0 + (day / 100);
    
//     // Create different task pools for each category
//     List<TaskModel> strengthTasks = _createStrengthTasks(difficulty, progressMultiplier);
//     List<TaskModel> enduranceTasks = _createEnduranceTasks(difficulty, progressMultiplier);
//     List<TaskModel> agilityTasks = _createAgilityTasks(difficulty, progressMultiplier);
//     List<TaskModel> intelligenceTasks = _createIntelligenceTasks(difficulty, progressMultiplier);
//     List<TaskModel> disciplineTasks = _createDisciplineTasks(difficulty, progressMultiplier);
    
//     // Combine all tasks and shuffle them
//     List<TaskModel> allTasks = [
//       ...strengthTasks, 
//       ...enduranceTasks, 
//       ...agilityTasks, 
//       ...intelligenceTasks, 
//       ...disciplineTasks
//     ];
//     allTasks.shuffle();
    
//     return allTasks;
//   }
  
//   // Create strength tasks based on difficulty
//   List<TaskModel> _createStrengthTasks(TaskDifficulty difficulty, double multiplier) {
//     List<TaskModel> tasks = [];
    
//     if (difficulty == TaskDifficulty.easy) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Push-ups',
//           description: 'Complete ${(10 * multiplier).round()} push-ups. You can do them on your knees if needed.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Squats',
//           description: 'Do ${(15 * multiplier).round()} bodyweight squats with proper form.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Lunges',
//           description: 'Complete ${(10 * multiplier).round()} lunges (each leg).',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Wall Sit',
//           description: 'Hold a wall sit position for ${(30 * multiplier).round()} seconds.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Calf Raises',
//           description: 'Do ${(20 * multiplier).round()} calf raises.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//       ]);
//     } else if (difficulty == TaskDifficulty.medium) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Push-ups',
//           description: 'Complete ${(20 * multiplier).round()} push-ups in proper form.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Tricep Dips',
//           description: 'Do ${(15 * multiplier).round()} tricep dips using a chair or stable surface.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Jump Squats',
//           description: 'Complete ${(15 * multiplier).round()} jump squats.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Glute Bridges',
//           description: 'Do ${(20 * multiplier).round()} glute bridges with a 2-second hold at the top.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Superman Hold',
//           description: 'Hold the superman position for ${(30 * multiplier).round()} seconds total.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//       ]);
//     } else { // hard
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Diamond Push-ups',
//           description: 'Complete ${(15 * multiplier).round()} diamond push-ups with proper form.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Pistol Squats',
//           description: 'Do ${(5 * multiplier).round()} pistol squats on each leg (use support if needed).',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Plank to Push-up',
//           description: 'Complete ${(10 * multiplier).round()} plank to push-up transitions.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Wall Push-ups',
//           description: 'Do ${(15 * multiplier).round()} wall push-ups (feet elevated on wall).',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Hollow Body Hold',
//           description: 'Hold the hollow body position for ${(30 * multiplier).round()} seconds total.',
//           difficulty: difficulty,
//           category: TaskCategory.strength,
//         ),
//       ]);
//     }
    
//     return tasks;
//   }
  
//   // Create endurance tasks based on difficulty
//   List<TaskModel> _createEnduranceTasks(TaskDifficulty difficulty, double multiplier) {
//     List<TaskModel> tasks = [];
    
//     if (difficulty == TaskDifficulty.easy) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'High Knees',
//           description: 'Do high knees in place for ${(30 * multiplier).round()} seconds.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Jogging in Place',
//           description: 'Jog in place for ${(1 * multiplier).round()} minute.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Arm Circles',
//           description: 'Do arm circles (forward and backward) for ${(30 * multiplier).round()} seconds each direction.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Marching in Place',
//           description: 'March in place with high knees for ${(2 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//       ]);
//     } else if (difficulty == TaskDifficulty.medium) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Jumping Jacks',
//           description: 'Complete ${(40 * multiplier).round()} jumping jacks.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Mountain Climbers',
//           description: 'Do mountain climbers for ${(45 * multiplier).round()} seconds.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Skipping in Place',
//           description: 'Skip in place for ${(2 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Jumping Jacks Variation',
//           description: 'Do ${(30 * multiplier).round()} jumping jacks with 4 different variations.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//       ]);
//     } else { // hard
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Burpees',
//           description: 'Complete ${(15 * multiplier).round()} burpees with proper form.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'High Intensity Interval Training',
//           description: '30 seconds on, 10 seconds off for 4 rounds of high knees, jumping jacks, and mountain climbers.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Shadow Boxing',
//           description: 'Shadow box with high intensity for ${(3 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Tabata Workout',
//           description: '20 seconds work, 10 seconds rest for 8 rounds alternating between two bodyweight exercises.',
//           difficulty: difficulty,
//           category: TaskCategory.endurance,
//         ),
//       ]);
//     }
    
//     return tasks;
//   }
  
//   // Create agility tasks based on difficulty
//   List<TaskModel> _createAgilityTasks(TaskDifficulty difficulty, double multiplier) {
//     List<TaskModel> tasks = [];
    
//     if (difficulty == TaskDifficulty.easy) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Side to Side Hops',
//           description: 'Hop side to side over an imaginary line for ${(30 * multiplier).round()} seconds.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Toe Taps',
//           description: 'Do toe taps in place for ${(30 * multiplier).round()} seconds.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Grapevine Steps',
//           description: 'Practice grapevine steps back and forth across the room for ${(1 * multiplier).round()} minute.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Arm Taps',
//           description: 'Tap opposite hand to knee for ${(30 * multiplier).round()} seconds.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//       ]);
//     } else if (difficulty == TaskDifficulty.medium) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Lateral Shuffle',
//           description: 'Lateral shuffle across the room for ${(1 * multiplier).round()} minute.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Jumping Cross-Jacks',
//           description: 'Complete ${(30 * multiplier).round()} jumping cross-jacks.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'High-Knee Twist',
//           description: 'Do high knees with a twist for ${(40 * multiplier).round()} seconds.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Fast Feet',
//           description: 'Do fast feet in place for ${(30 * multiplier).round()} seconds, then stop for direction changes.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//       ]);
//     } else { // hard
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Plyometric Lunges',
//           description: 'Do ${(20 * multiplier).round()} plyometric lunges, alternating legs.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Spider Crawls',
//           description: 'Complete spider crawls forward and backward across the room ${(3 * multiplier).round()} times.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Lateral Burpees',
//           description: 'Do ${(10 * multiplier).round()} burpees with a lateral jump between each rep.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Agility Drill',
//           description: 'Create a small agility course with pillows or markers and complete ${(10 * multiplier).round()} figure-8 paths as quickly as possible.',
//           difficulty: difficulty,
//           category: TaskCategory.agility,
//         ),
//       ]);
//     }
    
//     return tasks;
//   }
  
//   // Create intelligence tasks based on difficulty
//   List<TaskModel> _createIntelligenceTasks(TaskDifficulty difficulty, double multiplier) {
//     List<TaskModel> tasks = [];
    
//     if (difficulty == TaskDifficulty.easy) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Read a Book',
//           description: 'Read a book for ${(15 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Vocabulary Building',
//           description: 'Learn and write down ${(5 * multiplier).round()} new words with their meanings.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Mental Math',
//           description: 'Solve ${(10 * multiplier).round()} mental math problems without using a calculator.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Memory Game',
//           description: 'Look at a list of ${(10 * multiplier).round()} items for 1 minute, then try to recall them all.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//       ]);
//     } else if (difficulty == TaskDifficulty.medium) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Educational Video',
//           description: 'Watch an educational video on a new topic and take notes for ${(20 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Puzzle Solving',
//           description: 'Solve crossword, sudoku, or logic puzzles for ${(15 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Language Learning',
//           description: 'Practice a new language for ${(15 * multiplier).round()} minutes and learn ${(5 * multiplier).round()} phrases.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Mind Mapping',
//           description: 'Create a mind map about a topic you\'re interested in with at least ${(7 * multiplier).round()} branches.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//       ]);
//     } else { // hard
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Teach a Concept',
//           description: 'Research and prepare a 5-minute presentation on a complex topic you\'re unfamiliar with.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Critical Analysis',
//           description: 'Read an article and write a ${(300 * multiplier).round()}-word critical analysis.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Problem-Solving Challenge',
//           description: 'Find a complex problem in your field of interest and brainstorm ${(5 * multiplier).round()} potential solutions.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Memory Challenge',
//           description: 'Memorize a poem or speech of at least ${(20 * multiplier).round()} lines and recite it.',
//           difficulty: difficulty,
//           category: TaskCategory.intelligence,
//         ),
//       ]);
//     }
    
//     return tasks;
//   }
  
//   // Create discipline tasks based on difficulty
//   List<TaskModel> _createDisciplineTasks(TaskDifficulty difficulty, double multiplier) {
//     List<TaskModel> tasks = [];
    
//     if (difficulty == TaskDifficulty.easy) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Meditate',
//           description: 'Meditate for ${(5 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Gratitude Journal',
//           description: 'Write down ${(3 * multiplier).round()} things you\'re grateful for today.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'No Phone Hour',
//           description: 'Go ${(1 * multiplier).round()} hour without checking your phone.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Organized Space',
//           description: 'Organize and clean one small area of your living space.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//       ]);
//     } else if (difficulty == TaskDifficulty.medium) {
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Morning Routine',
//           description: 'Complete a morning routine with ${(5 * multiplier).round()} specific activities before starting your day.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Digital Detox',
//           description: 'Spend ${(3 * multiplier).round()} hours without using any digital devices.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Goal Setting',
//           description: 'Write down ${(3 * multiplier).round()} short-term and long-term goals with action steps for each.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Delayed Gratification',
//           description: 'Choose something you enjoy daily and delay it for ${(4 * multiplier).round()} hours.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//       ]);
//     } else { // hard
//       tasks.addAll([
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Cold Shower',
//           description: 'Take a cold shower for ${(3 * multiplier).round()} minutes.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Deep Work Session',
//           description: 'Complete a ${(90 * multiplier).round()}-minute deep work session without any distractions.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: 'Habit Breaking',
//           description: 'Identify a bad habit and abstain from it for the entire day while logging triggers and alternatives.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//         TaskModel(
//           id: _uuid.v4(),
//           title: '24-Hour Planning',
//           description: 'Plan your next 24 hours in 30-minute blocks and stick to the schedule.',
//           difficulty: difficulty,
//           category: TaskCategory.discipline,
//         ),
//       ]);
//     }
    
//     return tasks;
//   }
  
//   // Method to upload all days to a database or storage
//   Future<void> uploadAllDaysTasks() async {
//     // Get all the daily tasks
//     List<DailyTasks> allDays = createFiftyDayProgram();
    
//     // Here you would implement the actual upload to your database
//     // For example, using Firebase:
//     // 
//     // FirebaseFirestore firestore = FirebaseFirestore.instance;
//     // 
//     // for (var dayTasks in allDays) {
//     //   // First create a document for the day
//     //   DocumentReference dayRef = await firestore.collection('daily_tasks').add({
//     //     'dayNumber': dayTasks.dayNumber,
//     //     'id': dayTasks.id,
//     //   });
//     //   
//     //   // Then add each task as a sub-document
//     //   for (var task in dayTasks.tasks) {
//     //     await dayRef.collection('tasks').add({
//     //       'id': task.id,
//     //       'title': task.title,
//     //       'description': task.description,
//     //       'difficulty': task.difficulty.toString().split('.').last,
//     //       'category': task.category.toString().split('.').last,
//     //     });
//     //   }
//     // }
    
//     print('Successfully created 50 days of tasks with ${allDays.fold(0, (sum, day) => sum + day.tasks.length)} total tasks');
    
//     // Return sample data for the first few days to preview
//     print('Sample of first 2 days:');
//     for (int i = 0; i < 2; i++) {
//       print('Day ${allDays[i].dayNumber}: ${allDays[i].tasks.length} tasks');
//       for (var task in allDays[i].tasks) {
//         print('  - ${task.title} (${task.category.toString().split('.').last}, ${task.difficulty.toString().split('.').last})');
//       }
//     }
//   }
// }