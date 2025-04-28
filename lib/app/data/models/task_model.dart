enum TaskDifficulty { easy, medium, hard, extreme }
enum TaskStatus { pending, completed, failed }
enum TaskCategory { strength, endurance, agility, intelligence, discipline }

class TaskModel {
  String id;
  String title;
  String description;
  TaskDifficulty difficulty;
  TaskCategory category;
  TaskStatus status;
  DateTime? completedAt;
  bool isPenalty;
  DateTime createdAt;
  DateTime expiresAt;
  int statPoints;
  int xpPoints;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    this.status = TaskStatus.pending,
    this.completedAt,
    this.isPenalty = false,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? statPoints,
    int? xpPoints,
  })  : createdAt = createdAt ?? DateTime.now(),
        expiresAt = expiresAt ?? DateTime.now().add(Duration(days: 1)),
        statPoints = statPoints ?? _calculateStatPoints(difficulty),
        xpPoints = xpPoints ?? _calculateXpPoints(difficulty);

  // Calculate stat points based on difficulty
  static int _calculateStatPoints(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return 2;
      case TaskDifficulty.medium:
        return 4;
      case TaskDifficulty.hard:
        return 6;
      case TaskDifficulty.extreme:
        return 10;
    }
  }

  // Calculate XP points based on difficulty
  static int _calculateXpPoints(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return 10;
      case TaskDifficulty.medium:
        return 25;
      case TaskDifficulty.hard:
        return 50;
      case TaskDifficulty.extreme:
        return 100;
    }
  }

  // Check if task has expired
  bool isExpired() {
    return DateTime.now().isAfter(expiresAt);
  }

  // Mark task as completed
  void complete() {
    status = TaskStatus.completed;
    completedAt = DateTime.now();
  }

  // Mark task as failed
  void fail() {
    status = TaskStatus.failed;
  }
bool get isCompleted {
  return status == TaskStatus.completed;
}
  // Convert Task to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty.toString().split('.').last,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'isPenalty': isPenalty,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'statPoints': statPoints,
      'xpPoints': xpPoints,
    };
  }

  // Create from Firebase map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      difficulty: _difficultyFromString(map['difficulty']),
      category: _categoryFromString(map['category']),
      status: _statusFromString(map['status']),
      completedAt: map['completedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['completedAt']) : null,
      isPenalty: map['isPenalty'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(map['expiresAt']),
      statPoints: map['statPoints'],
      xpPoints: map['xpPoints'],
    );
  }

  static TaskDifficulty _difficultyFromString(String value) {
    return TaskDifficulty.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => TaskDifficulty.easy,
    );
  }

  static TaskCategory _categoryFromString(String value) {
    return TaskCategory.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => TaskCategory.strength,
    );
  }

  static TaskStatus _statusFromString(String value) {
    return TaskStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => TaskStatus.pending,
    );
  }
}

