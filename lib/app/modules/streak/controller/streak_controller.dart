// streak_controller.dart
import 'package:get/get.dart';
import '../../../data/models/streak_model.dart';
import '../../../data/services/database_service.dart';

class StreakController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  
  final Rx<StreakModel> streak = StreakModel().obs;
  final RxBool isLoading = true.obs;
  final RxBool hasReward = false.obs;
  final RxString rewardTitle = ''.obs;
  final RxString rewardDescription = ''.obs;
  final RxInt xpReward = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadStreakData();
  }
  
  Future<void> _loadStreakData() async {
  try {
    isLoading.value = true;
    
    // Fix for nullable StreakModel
    StreakModel? userStreak = await _databaseService.getUserStreak();
    if (userStreak != null) {
      streak.value = userStreak;
    } else {
      streak.value = StreakModel(); // Use default streak model if null
    }
    
    _checkForStreakReward();
    isLoading.value = false;
  } catch (e) {
    isLoading.value = false;
    Get.snackbar('Error', 'Failed to load streak data: ${e.toString()}');
  }
}
  
  void _checkForStreakReward() {
    hasReward.value = false;
    
    // Check for streak rewards
    if (streak.value.currentStreak == 3) {
      hasReward.value = true;
      rewardTitle.value = '3-Day Streak!';
      rewardDescription.value = 'Youve maintained your discipline for 3 days!';
      xpReward.value = 50;
    } else if (streak.value.currentStreak == 7) {
      hasReward.value = true;
      rewardTitle.value = '7-Day Streak!';
      rewardDescription.value = 'A full week of training! Bonus task unlocked!';
      xpReward.value = 100;
    } else if (streak.value.currentStreak == 30) {
      hasReward.value = true;
      rewardTitle.value = 'Steadfast Hunter';
      rewardDescription.value = 'A month of consistent training! Your resolve is unmatched!';
      xpReward.value = 500;
    }
  }
  
  Future<void> claimStreakReward() async {
    if (hasReward.value) {
      try {
        // Award XP
        await _databaseService.addUserXP(xpReward.value);
        
        // For the 7-day streak, add bonus task
        if (streak.value.currentStreak == 7) {
          await _databaseService.addBonusTask();
        }
        
        // For 30-day streak, add special title
        if (streak.value.currentStreak == 30) {
          await _databaseService.addUserTitle("Steadfast Hunter");
        }
        
        Get.snackbar(
          'Reward Claimed',
          'You have received ${xpReward.value} XP for your streak!'
        );
        
        // Mark reward as claimed
        await _databaseService.markStreakRewardClaimed(streak.value.currentStreak);
        hasReward.value = false;
        
        Get.back(); // Return to previous screen
      } catch (e) {
        Get.snackbar('Error', 'Failed to claim reward: ${e.toString()}');
      }
    }
  }
}