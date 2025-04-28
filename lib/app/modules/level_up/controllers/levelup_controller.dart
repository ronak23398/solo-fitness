// levelup_controller.dart
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/database_service.dart';

class LevelupController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  
  final Rx<UserModel> user = UserModel().obs;
  final RxBool isClassUpgrade = false.obs;
  final RxString previousClass = ''.obs;
  final RxString newClass = ''.obs;
  final RxInt previousLevel = 0.obs;
  final RxInt newLevel = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    _getLevelUpData();
  }
  
  void _getLevelUpData() {
    // Get data from parameters
    Map<String, dynamic> params = Get.arguments;
    
    if (params != null) {
      previousLevel.value = params['previousLevel'] ?? 1;
      newLevel.value = params['newLevel'] ?? 2;
      previousClass.value = params['previousClass'] ?? 'E-Class';
      newClass.value = params['newClass'] ?? 'E-Class';
      isClassUpgrade.value = previousClass.value != newClass.value;
    }
  }
  
  String getLevelUpMessage() {
    if (isClassUpgrade.value) {
      return 'Congratulations, Hunter! You have risen to ${newClass.value}!';
    } else {
      return 'Level Up! You are now Level ${newLevel.value}';
    }
  }
  
  Future<void> continueToDashboard() async {
    Get.offAllNamed('/home');
  }
}