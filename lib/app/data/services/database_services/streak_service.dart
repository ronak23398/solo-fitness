import 'package:firebase_database/firebase_database.dart';
import 'package:solo_fitness/app/data/models/streak_model.dart';

/// Service for streak-related operations
class StreakService {
  final FirebaseDatabase _database;
  String? _currentUserUid;

  StreakService(this._database);

  void setCurrentUser(String uid) {
    _currentUserUid = uid;
  }

  Future<StreakModel?> getUserStreak() async {
    try {
      if (_currentUserUid == null) {
        throw Exception('User not authenticated');
      }
      
      final DatabaseReference streakRef = _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
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

  // Mark streak reward as claimed
  Future<void> markStreakRewardClaimed(int streakDay) async {
    try {
      if (_currentUserUid == null) {
        throw Exception('User not authenticated');
      }
      
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
      await _database
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
}