// streak_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import 'package:solo_fitness/app/modules/streak/controller/streak_controller.dart';

class StreakView extends GetView<StreakController> {
  const StreakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('Daily Streak', style: AppTextStyles.headerWhite),
        backgroundColor: AppColors.darkPurple,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonBlue),
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentStreakSection(),
              SizedBox(height: 16),
              _buildStreakProgressSection(),
              SizedBox(height: 24),
              _buildRewardsSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStreakSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkPurple, AppColors.deepBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neonBlue, width: 2),
                  color: AppColors.darkBlue,
                ),
                child: Center(
                  child: Text(
                    '${controller.streak.value.currentStreak}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: AppColors.neonBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.streak.value.currentStreak == 1
                        ? '1 Day Streak'
                        : '${controller.streak.value.currentStreak} Days Streak',
                    style: AppTextStyles.titleWhite,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Highest: ${controller.streak.value.maxStreak} days',
                    style: AppTextStyles.subtitleGrey,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            _getStreakMotivationalMessage(),
            style: AppTextStyles.bodyWhite,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStreakMotivationalMessage() {
    final streak = controller.streak.value.currentStreak;
    
    if (streak == 0) {
      return "Begin your journey as a hunter today!";
    } else if (streak < 3) {
      return "You're taking your first steps. Keep going!";
    } else if (streak < 7) {
      return "Your consistency is building power within you.";
    } else if (streak < 14) {
      return "A week of dedication - your hunter spirit grows stronger!";
    } else if (streak < 30) {
      return "Your commitment is impressive. You're rising through the ranks!";
    } else if (streak < 50) {
      return "A true hunter's dedication! Your path to greatness continues.";
    } else if (streak < 100) {
      return "Few hunters reach this level of consistency. Remarkable!";
    } else {
      return "Your legendary dedication puts you among the elite hunters!";
    }
  }

  Widget _buildStreakProgressSection() {
    // Create a default milestone
    Map<String, dynamic> nextMilestone = {};
    
    // Calculate next milestone
    int currentStreak = controller.streak.value.currentStreak;
    if (currentStreak < 3) {
      nextMilestone = {
        'days': 3,
        'reward': '50 XP + Achievement',
        'icon': 'assets/icons/streak_3.png',
      };
    } else if (currentStreak < 7) {
      nextMilestone = {
        'days': 7,
        'reward': '100 XP + Bonus Task',
        'icon': 'assets/icons/streak_7.png',
      };
    } else if (currentStreak < 30) {
      nextMilestone = {
        'days': 30,
        'reward': '500 XP + Steadfast Hunter Title',
        'icon': 'assets/icons/streak_30.png',
      };
    } else if (currentStreak < 100) {
      nextMilestone = {
        'days': 100,
        'reward': '1000 XP + Legendary Hunter Title',
        'icon': 'assets/icons/streak_100.png',
      };
    } else {
      nextMilestone = {
        'days': currentStreak + 50,
        'reward': 'Continued Excellence',
        'icon': 'assets/icons/streak_master.png',
      };
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              'Next Milestone',
              style: AppTextStyles.headerWhite,
            ),
          ),
          if (nextMilestone.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.purpleAccent.withOpacity(0.5), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.darkPurple,
                    ),
                    child: Center(
                      child: Image.asset(
                        nextMilestone['icon'] ?? 'assets/icons/default.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${nextMilestone['days']} Day Streak',
                          style: AppTextStyles.subtitleNeonBlue,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${nextMilestone['reward']}',
                          style: AppTextStyles.bodyWhite,
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: controller.streak.value.currentStreak / (nextMilestone['days'] ?? 1),
                          backgroundColor: AppColors.darkBackground,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonBlue),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${controller.streak.value.currentStreak}/${nextMilestone['days']} days',
                          style: AppTextStyles.subtitleGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    // Define streak rewards
    List<Map<String, dynamic>> streakRewards = [
      {
        'days': 3,
        'reward': '3-Day Streak Reward',
        'description': 'You\'ve maintained your discipline for 3 days!',
        'claimed': controller.streak.value.rewards['day3'] ?? false,
      },
      {
        'days': 7,
        'reward': '7-Day Streak Reward',
        'description': 'A full week of training! Bonus task unlocked!',
        'claimed': controller.streak.value.rewards['day7'] ?? false,
      },
      {
        'days': 30,
        'reward': 'Steadfast Hunter',
        'description': 'A month of consistent training! Your resolve is unmatched!',
        'claimed': controller.streak.value.rewards['day30'] ?? false,
      },
      {
        'days': 100,
        'reward': 'Legendary Hunter',
        'description': '100 days of dedication! You are now among the elite!',
        'claimed': false, // This is not in your default rewards map, so default to false
      },
    ];
    
    // Calculate if there's a new unclaimed reward
    bool hasNewReward = false;
    for (var reward in streakRewards) {
      if (controller.streak.value.currentStreak >= reward['days'] && 
          reward['claimed'] == false) {
        hasNewReward = true;
        break;
      }
    }

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Row(
              children: [
                Text(
                  'Streak Rewards',
                  style: AppTextStyles.headerWhite,
                ),
                SizedBox(width: 8),
                if (hasNewReward)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: streakRewards.length,
            itemBuilder: (context, index) {
              final reward = streakRewards[index];
              final bool isAchieved = controller.streak.value.currentStreak >= reward['days'];
              final bool isClaimed = reward['claimed'] == true;
              
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isAchieved 
                      ? (isClaimed 
                          ? AppColors.darkGrey.withOpacity(0.4) 
                          : AppColors.darkPurple.withOpacity(0.8))
                      : AppColors.darkGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isAchieved 
                        ? (isClaimed 
                            ? AppColors.lightGrey.withOpacity(0.3) 
                            : AppColors.neonBlue)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isAchieved 
                              ? (isClaimed ? AppColors.darkGrey : AppColors.purpleAccent) 
                              : AppColors.darkBackground,
                        ),
                        child: Center(
                          child: Text(
                            '${reward['days']}',
                            style: TextStyle(
                              color: isAchieved 
                                  ? (isClaimed ? AppColors.lightGrey : Colors.white) 
                                  : AppColors.lightGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward['reward'],
                              style: isAchieved 
                                  ? (isClaimed 
                                      ? AppTextStyles.subtitleGrey 
                                      : AppTextStyles.subtitleNeonBlue)
                                  : AppTextStyles.subtitleGrey,
                            ),
                            SizedBox(height: 4),
                            Text(
                              reward['description'],
                              style: isAchieved 
                                  ? (isClaimed 
                                      ? AppTextStyles.smallBodyGrey 
                                      : AppTextStyles.smallBodyWhite)
                                  : AppTextStyles.smallBodyGrey,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      isAchieved
                          ? (isClaimed
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGrey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'CLAIMED',
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => controller.claimStreakReward(),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [AppColors.neonBlue, AppColors.purpleAccent],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.neonBlue.withOpacity(0.3),
                                          blurRadius: 5,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'CLAIM',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ))
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.darkGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'LOCKED',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}