import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/database_service.dart';
import '../../../data/services/auth_service.dart';

class ProfileController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  final AuthService _authService = Get.find<AuthService>();
  
  final Rx<UserModel> user = UserModel().obs;
  final RxBool isLoading = true.obs;
  final RxDouble levelProgress = 0.0.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }
  
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      
      // Get current user ID from auth service
      String userId = _authService.currentUser.value!.id ?? '';
      
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }
      
      UserModel? userData = await _databaseService.getUser(userId);
      if (userData != null) {
        user.value = userData;
        levelProgress.value = userData.calculateLevelProgress();
      } else {
        throw Exception('User data not found');
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}');
    }
  }
  
  String getCurrentClass() {
    return user.value.getFullClassName();
  }
  
  // Get XP required for a specific level
  int _getXPRequiredForLevel(int level) {
    return user.value.calculateRequiredXp(level);
  }
  
  Future<void> refreshProfile() async {
    await _loadUserProfile();
  }
}