import 'package:firebase_database/firebase_database.dart';
import 'package:solo_fitness/app/data/models/streak_model.dart';
import 'package:solo_fitness/app/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

/// Service for user-related operations
class UserService {
  final FirebaseDatabase _database;
  final Uuid _uuid;
  String? _currentUserUid;

  UserService(this._database, this._uuid);

  void setCurrentUser(String uid) {
    _currentUserUid = uid;
  }

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

  // Add XP to user
  Future<void> addUserXP(int xpAmount) async {
    try {
      if (_currentUserUid == null) {
        throw Exception('User not authenticated');
      }
      
      final DatabaseReference userXpRef = _database
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

  // Add a title to user profile
  Future<void> addUserTitle(String title) async {
    try {
      if (_currentUserUid == null) {
        throw Exception('User not authenticated');
      }
      
      final DatabaseReference titlesRef = _database
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
      await _database
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

  // Reset user (if they choose not to use Black Heart)
  Future<void> resetUser(Function getCurrentUserDay) async {
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
      await getCurrentUserDay(_currentUserUid!);
    } catch (e) {
      throw Exception('Failed to reset user: ${e.toString()}');
    }
  }

  // Add stat points to user's stats
  Future<void> addUserStats(String category, int points) async {
    if (_currentUserUid == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Get current stat value
      DatabaseReference statRef = _database
          .ref()
          .child('users')
          .child(_currentUserUid!)
          .child('stats')
          .child(category);

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
}