import 'package:flutter/material.dart';
import 'package:solo_fitness/app/data/models/task_model.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class PenaltyTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final TaskDifficulty difficulty;
  final bool isCompleted;
  final VoidCallback onComplete;
  final String deadline;

  const PenaltyTaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.isCompleted,
    required this.onComplete,
    required this.deadline,
  }) : super(key: key);

  Color get difficultyColor {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return AppColors.successDarkGreen;
      case TaskDifficulty.medium:
        return AppColors.warningYellow;
      case TaskDifficulty.hard:
        return AppColors.aClassColor;
      case TaskDifficulty.extreme:
        return AppColors.deathRed;
    }
  }

  String get difficultyName {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return 'Easy';
      case TaskDifficulty.medium:
        return 'Medium';
      case TaskDifficulty.hard:
        return 'Hard';
      case TaskDifficulty.extreme:
        return 'Extreme';
    }
  }

  String get rewardText {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return '+2 Points, +10 XP';
      case TaskDifficulty.medium:
        return '+4 Points, +25 XP';
      case TaskDifficulty.hard:
        return '+6 Points, +50 XP';
      case TaskDifficulty.extreme:
        return '+10 Points, +100 XP';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isCompleted 
            ? AppColors.darkGrey.withOpacity(0.6)
            : AppColors.darkRed.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppColors.darkGrey
              : AppColors.dangerRed.withOpacity(0.7),
          width: 1.5,
        ),
        boxShadow: [
          if (!isCompleted)
            BoxShadow(
              color: AppColors.dangerRed.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Penalty badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'PENALTY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Difficulty badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: difficultyColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        difficultyName,
                        style: TextStyle(
                          color: difficultyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Task title
                Text(
                  title,
                  style: isCompleted 
                      ? AppTextStyles.subtitleGrey.copyWith(
                          decoration: TextDecoration.lineThrough,
                        )
                      : AppTextStyles.subtitleWhite,
                ),
                
                SizedBox(height: 6),
                
                // Task description
                Text(
                  description,
                  style: isCompleted
                      ? AppTextStyles.smallBodyGrey.copyWith(
                          decoration: TextDecoration.lineThrough,
                        )
                      : AppTextStyles.smallBodyWhite,
                ),
                
                SizedBox(height: 16),
                
                // Warning text
                if (!isCompleted)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.darkRed.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.dangerRed.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          color: AppColors.dangerRed,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Complete this task before $deadline or you will die and lose progress!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                SizedBox(height: 16),
                
                // Bottom row with reward and complete button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reward text
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: isCompleted 
                              ? AppColors.lightGrey
                              : AppColors.goldAccent,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          rewardText,
                          style: isCompleted
                              ? AppTextStyles.smallBodyGrey
                              : TextStyle(
                                  color: AppColors.goldAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ],
                    ),
                    
                    // Complete button
                    if (!isCompleted)
                      GestureDetector(
                        onTap: onComplete,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.dangerRed, AppColors.dangerDarkRed],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.dangerRed.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Complete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.successGreen.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.successGreen,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Completed',
                              style: TextStyle(
                                color: AppColors.successGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}