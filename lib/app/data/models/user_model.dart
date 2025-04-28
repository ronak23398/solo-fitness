class UserModel {
  String? id;
  String? email;
  String? username; // Added username for display purposes
  String? photoUrl;
  int level;
  String playerClass;
  int xp;
  int requiredXpForNextLevel;
  Map<String, int> stats;
  int currentStreak; // Renamed for clarity
  int longestStreak; // Added to track longest streak
  List<String> titles; // Added for achievements
  int tasksCompleted; // Added to track completed tasks
  int blackHearts;
  bool isDead;
  DateTime lastLogin;
  DateTime createdAt;
  DateTime? lastCompletionDate; 
  int currentday;// Added to track last task completion
  
  UserModel({
    this.id,
    this.email,
    this.username,
    this.currentday = 1,
    this.photoUrl,
    this.level = 1,
    this.playerClass = 'E',
    this.xp = 0,
    this.requiredXpForNextLevel = 100,
    Map<String, int>? stats,
    this.currentStreak = 0,
    this.longestStreak = 0,
    List<String>? titles,
    this.tasksCompleted = 0,
    this.blackHearts = 0,
    this.isDead = false,
    this.lastCompletionDate,
    DateTime? lastLogin,
    DateTime? createdAt,
  })  : stats = stats ?? {
          'strength': 0,
          'endurance': 0,
          'agility': 0,
          'intelligence': 0,
          'discipline': 0,
        },
        titles = titles ?? [],
        lastLogin = lastLogin ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  // Calculate the required XP for the next level
  int calculateRequiredXp(int level) {
    // Formula: Base (100) * level factor
    return (100 * (1 + (level * 0.5))).toInt();
  }

  // Check if user should level up
  bool shouldLevelUp() {
    return xp >= requiredXpForNextLevel;
  }

  // Process level up
  void levelUp() {
    level++;
    xp = xp - requiredXpForNextLevel;
    requiredXpForNextLevel = calculateRequiredXp(level);
    updatePlayerClass();
  }

  // Update player class based on level
  void updatePlayerClass() {
    if (level >= 86) {
      playerClass = 'SS';
    } else if (level >= 71) {
      playerClass = 'S';
    } else if (level >= 51) {
      playerClass = 'A';
    } else if (level >= 36) {
      playerClass = 'B';
    } else if (level >= 21) {
      playerClass = 'C';
    } else if (level >= 11) {
      playerClass = 'D';
    } else {
      playerClass = 'E';
    }
  }

  // Get full class name with dash (for display purposes)
  String getFullClassName() {
    return '$playerClass-Class';
  }

  // Calculate level progress (0.0 to 1.0) for progress bar
  double calculateLevelProgress() {
    if (requiredXpForNextLevel <= 0) return 1.0;
    return xp / requiredXpForNextLevel;
  }

  // Calculate XP remaining to next level
  int xpToNextLevel() {
    return requiredXpForNextLevel - xp;
  }

  // Check if user has a streak reward to claim
  bool hasStreakReward() {
    // Reward at every 7 days (7, 14, 21, etc.)
    return currentStreak > 0 && currentStreak % 7 == 0;
  }
  
 // Get streak information in a format compatible with the profile view
UserStreak get streak {
  return UserStreak(
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    lastCompletionDate: lastCompletionDate,
  );
}
  
  // Getter for strength stat
  int get strength => stats['strength'] ?? 0;
  
  // Getter for endurance stat
  int get endurance => stats['endurance'] ?? 0;
  
  // Getter for agility stat
  int get agility => stats['agility'] ?? 0;
  
  // Getter for intelligence stat
  int get intelligence => stats['intelligence'] ?? 0;
  
  // Getter for discipline stat
  int get discipline => stats['discipline'] ?? 0;

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username, // Fall back to displayName if username is null
      'photoUrl': photoUrl,
      'level': level,
      'currentday': currentday,
      'playerClass': playerClass,
      'xp': xp,
      'requiredXpForNextLevel': requiredXpForNextLevel,
      'stats': stats,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'titles': titles,
      'tasksCompleted': tasksCompleted,
      'blackHearts': blackHearts,
      'isDead': isDead,
      'lastCompletionDate': lastCompletionDate?.millisecondsSinceEpoch,
      'lastLogin': lastLogin.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create from Firebase map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      username: map['username'] ?? map['displayName'],
      photoUrl: map['photoUrl'],
      currentday: map['currentday'],
      level: map['level'] ?? 1,
      playerClass: map['playerClass'] ?? 'E',
      xp: map['xp'] ?? 0,
      requiredXpForNextLevel: map['requiredXpForNextLevel'] ?? 100,
      stats: Map<String, int>.from(map['stats'] ?? {
        'strength': 0,
        'endurance': 0,
        'agility': 0,
        'intelligence': 0,
        'discipline': 0,
      }),
      currentStreak: map['currentStreak'] ?? map['streak'] ?? 0, // Support both field names
      longestStreak: map['longestStreak'] ?? 0,
      titles: List<String>.from(map['titles'] ?? []),
      tasksCompleted: map['tasksCompleted'] ?? 0,
      blackHearts: map['blackHearts'] ?? 0,
      isDead: map['isDead'] ?? false,
      lastCompletionDate: map['lastCompletionDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastCompletionDate']) 
          : null,
      lastLogin: DateTime.fromMillisecondsSinceEpoch(map['lastLogin'] ?? DateTime.now().millisecondsSinceEpoch),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }
}

// Helper class to match the profile view expectations
class UserStreak {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletionDate;

  UserStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletionDate,
  });
}

// Helper class to expose stats in an object-oriented way
class UserStats {
  final Map<String, int> _stats;

  UserStats(this._stats);

  int get strength => _stats['strength'] ?? 0;
  int get endurance => _stats['endurance'] ?? 0;
  int get agility => _stats['agility'] ?? 0;
  int get intelligence => _stats['intelligence'] ?? 0;
  int get discipline => _stats['discipline'] ?? 0;

  Map<String, dynamic> toMap() => _stats;

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(Map<String, int>.from(map));
  }
}