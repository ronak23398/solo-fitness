import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'database_services/services_index.dart';


/// Main database service that delegates to specialized services
class DatabaseService extends GetxService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Uuid _uuid = Uuid();
  String? _currentUserUid;

  // Individual services
  late UserService userService;
  late TaskService taskService;
  late StreakService streakService;
  late StoreService storeService;

  // Initialize services
  DatabaseService() {
    userService = UserService(_database, _uuid);
    taskService = TaskService(_database, _uuid);
    streakService = StreakService(_database);
    storeService = StoreService( );
  }

  void setCurrentUser(String uid) {
    _currentUserUid = uid;
    
    // Update current user in all services
    userService.setCurrentUser(uid);
    taskService.setCurrentUser(uid);
    streakService.setCurrentUser(uid);
  }

  String? get currentUserUid => _currentUserUid;
}