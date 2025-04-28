class StreakModel {
  int currentStreak;
  int maxStreak;
  DateTime lastUpdated;
  Map<String, bool> rewards;

  StreakModel({
    this.currentStreak = 0,
    this.maxStreak = 0,
    DateTime? lastUpdated,
    Map<String, bool>? rewards,
  })  : lastUpdated = lastUpdated ?? DateTime.now(),
        rewards = rewards ?? {
          'day3': false,
          'day7': false,
          'day30': false,
        };

  // Check if streak is broken (more than 1 day since last update)
  bool isStreakBroken() {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    return lastUpdated.isBefore(yesterday);
  }

  // Update streak
  void updateStreak() {
    final now = DateTime.now();
    
    // If more than one day has passed, reset streak
    if (isStreakBroken()) {
      currentStreak = 1;
    } else {
      // Check if it's a new day (not the same day as lastUpdated)
      if (now.day != lastUpdated.day || 
          now.month != lastUpdated.month || 
          now.year != lastUpdated.year) {
        currentStreak++;
      }
    }
    
    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
    }
    
    lastUpdated = now;
    
    // Check if rewards should be unlocked
    if (currentStreak >= 3 && rewards['day3'] == false) {
      rewards['day3'] = true;
    }
    if (currentStreak >= 7 && rewards['day7'] == false) {
      rewards['day7'] = true;
    }
    if (currentStreak >= 30 && rewards['day30'] == false) {
      rewards['day30'] = true;
    }
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'rewards': rewards,
    };
  }

  // Create from Firebase map
  factory StreakModel.fromMap(Map<String, dynamic> map) {
    return StreakModel(
      currentStreak: map['currentStreak'] ?? 0,
      maxStreak: map['maxStreak'] ?? 0,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated'] ?? DateTime.now().millisecondsSinceEpoch),
      rewards: Map<String, bool>.from(map['rewards'] ?? {
        'day3': false,
        'day7': false,
        'day30': false,
      }),
    );
  }
}