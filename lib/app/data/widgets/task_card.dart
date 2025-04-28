import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

enum TaskCategory { strength, endurance, agility, intelligence, discipline }
enum TaskDifficulty { easy, medium, hard, extreme }

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final TaskCategory category;
  final TaskDifficulty difficulty;
  final bool isCompleted;
  final VoidCallback onComplete;
  final bool isPenalty;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.isCompleted,
    required this.onComplete,
    this.isPenalty = false,
  }) : super(key: key);

  Color get categoryColor {
    switch (category) {
      case TaskCategory.strength:
        return AppColors.strengthColor;
      case TaskCategory.endurance:
        return AppColors.enduranceColor;
      case TaskCategory.agility:
        return AppColors.agilityColor;
      case TaskCategory.intelligence:
        return AppColors.intelligenceColor;
      case TaskCategory.discipline:
        return AppColors.disciplineColor;
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return AppColors.successGreen;
      case TaskDifficulty.medium:
        return AppColors.warningYellow;
      case TaskDifficulty.hard:
        return AppColors.aClassColor; // Using aClassColor as orange for hard difficulty
      case TaskDifficulty.extreme:
        return AppColors.dangerRed;
    }
  }

  String get categoryName {
    switch (category) {
      case TaskCategory.strength:
        return 'Strength';
      case TaskCategory.endurance:
        return 'Endurance';
      case TaskCategory.agility:
        return 'Agility';
      case TaskCategory.intelligence:
        return 'Intelligence';
      case TaskCategory.discipline:
        return 'Discipline';
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

  IconData get categoryIcon {
    switch (category) {
      case TaskCategory.strength:
        return Icons.fitness_center;
      case TaskCategory.endurance:
        return Icons.timer;
      case TaskCategory.agility:
        return Icons.directions_run;
      case TaskCategory.intelligence:
        return Icons.psychology;
      case TaskCategory.discipline:
        return Icons.self_improvement;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isPenalty 
            ? AppColors.deathRed.withOpacity(0.4)
            : (isCompleted 
                ? AppColors.darkGrey.withOpacity(0.6)
                : AppColors.darkBlue.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPenalty
              ? AppColors.dangerRed.withOpacity(0.7)
              : (isCompleted
                  ? AppColors.darkGrey
                  : categoryColor.withOpacity(0.6)),
          width: 1,
        ),
        boxShadow: [
          if (!isCompleted)
            BoxShadow(
              color: isPenalty
                  ? AppColors.dangerRed.withOpacity(0.2)
                  : categoryColor.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Category indicator
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 6,
              child: Container(
                color: isPenalty ? AppColors.dangerRed : categoryColor,
              ),
            ),
            
            // Main content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category with icon
                      Row(
                        children: [
                          Icon(
                            categoryIcon,
                            color: isPenalty ? AppColors.dangerRed : categoryColor,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            categoryName,
                            style: TextStyle(
                              color: isPenalty ? AppColors.dangerRed : categoryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
                  
                  SizedBox(height: 10),
                  
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
                                colors: isPenalty
                                    ? [AppColors.dangerRed, AppColors.dangerDarkRed]
                                    : [AppColors.neonBlue, AppColors.purpleAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: isPenalty
                                      ? AppColors.dangerRed.withOpacity(0.3)
                                      : AppColors.neonBlue.withOpacity(0.3),
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
            
            // Penalty badge
            if (isPenalty)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'PENALTY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}