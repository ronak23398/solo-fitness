import 'package:flutter/material.dart';
import 'dart:async';
import 'package:solo_fitness/app/data/theme/colors.dart';
import 'package:solo_fitness/app/data/theme/text_styles.dart';
import '../../../data/models/task_model.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onCompleted;

  const TaskTile({Key? key, required this.task, required this.onCompleted})
    : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _timer;
  int _seconds = 0;
  bool _isQuestActive = false;
  final ValueNotifier<int> _timerNotifier = ValueNotifier<int>(0);


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

 @override
void dispose() {
  _timer?.cancel();
  _timerNotifier.dispose();
  super.dispose();
}

 void startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    _seconds++;
    _timerNotifier.value = _timerNotifier.value + 1; // Just increment to trigger rebuild
  });
}

  void _stopTimer() {
    _timer?.cancel();
    _isQuestActive = false;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showQuestDialog() {
    startTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: _getBorderColor(widget.task.category),
                  width: 1.5,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quest Header with Animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getBorderColor(
                                widget.task.category,
                              ).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: _buildCategoryIcon(),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'QUEST IN PROGRESS',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: _getBorderColor(widget.task.category),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                _getCategoryString(
                                  widget.task.category,
                                ).toUpperCase(),
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getBorderColor(
                                    widget.task.category,
                                  ).withOpacity(0.8),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Task Title with Animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkBackground,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _getBorderColor(
                                widget.task.category,
                              ).withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task.title,
                              style: AppTextStyles.taskTitle.copyWith(
                                fontSize: 20,
                                height: 1.3,
                              ),
                            ),
                            if (widget.task.description.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                widget.task.description,
                                style: AppTextStyles.bodyWhite.copyWith(
                                  color: AppColors.lightGrey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Timer and Rewards
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, double value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      child: Column(
                        children: [
                          // Timer Display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.darkBackground,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.primaryBlue.withOpacity(0.5),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonBlueGlow.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ValueListenableBuilder(
                              valueListenable:
                                  _timerNotifier, // Replace with a ValueNotifier you define
                              builder: (context, _, __) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.timer,
                                      color: AppColors.primaryBlue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTime(_seconds),
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlue,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Rewards
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRewardChip(
                                Icons.add_chart,
                                '${widget.task.statPoints}',
                                _getCategoryString(widget.task.category),
                                _getBorderColor(
                                  widget.task.category,
                                ).withOpacity(0.15),
                                _getBorderColor(widget.task.category),
                              ),
                              const SizedBox(width: 16),
                              _buildRewardChip(
                                Icons.star,
                                '${widget.task.xpPoints}',
                                'XP',
                                AppColors.xpPointsBg,
                                AppColors.xpPointsText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Complete Button with Animation
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1200),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonBlueGlow.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _stopTimer();
                            Navigator.of(context).pop();

                            // Run leveling up animation
                            _animationController.reset();
                            _animationController.forward();

                            // Slight delay before completing the task
                            Future.delayed(
                              const Duration(milliseconds: 800),
                              () {
                                widget.onCompleted();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'COMPLETE QUEST',
                            style: AppTextStyles.buttonText.copyWith(
                              fontSize: 16,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        _stopTimer();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: AppColors.mediumGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              widget.task.status == TaskStatus.completed
                  ? AppColors.successDarkGreen.withOpacity(0.5)
                  : _getBorderColor(widget.task.category).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          if (widget.task.status != TaskStatus.completed)
            BoxShadow(
              color: _getBorderColor(widget.task.category).withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 0,
            ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Solo Leveling inspired animation when completing task
          final glowOpacity = _animationController.value;
          final scaleValue = 1.0 + (_animationController.value * 0.03);

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (glowOpacity > 0)
                  BoxShadow(
                    color: _getBorderColor(
                      widget.task.category,
                    ).withOpacity(glowOpacity * 0.8),
                    blurRadius: 20 * glowOpacity,
                    spreadRadius: 4 * glowOpacity,
                  ),
              ],
            ),
            child: Transform.scale(scale: scaleValue, child: child),
          );
        },
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.task.status == TaskStatus.completed ? null : null,
            splashColor: _getBorderColor(widget.task.category).withOpacity(0.1),
            highlightColor: _getBorderColor(
              widget.task.category,
            ).withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _getBorderColor(
                            widget.task.category,
                          ).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: _buildCategoryIcon(),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _getCategoryString(widget.task.category).toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getBorderColor(widget.task.category),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      _buildDifficultyIndicator(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task.title,
                              style: AppTextStyles.taskTitle.copyWith(
                                fontSize: 18,
                                decoration:
                                    widget.task.status == TaskStatus.completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                color:
                                    widget.task.status == TaskStatus.completed
                                        ? AppColors.textLightDisabled
                                        : AppColors.textLight,
                                height: 1.3,
                              ),
                            ),
                            if (widget.task.description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                widget.task.description,
                                style: AppTextStyles.bodyWhite.copyWith(
                                  color:
                                      widget.task.status == TaskStatus.completed
                                          ? AppColors.mediumGrey
                                          : AppColors.lightGrey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.task.status == TaskStatus.completed)
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Icon(
                            Icons.check_circle,
                            color: AppColors.successGreen,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _buildRewardChip(
                        Icons.add_chart,
                        '${widget.task.statPoints}',
                        _getCategoryString(widget.task.category),
                        _getBorderColor(widget.task.category).withOpacity(0.15),
                        _getBorderColor(widget.task.category),
                      ),
                      const SizedBox(width: 10),
                      _buildRewardChip(
                        Icons.star,
                        '${widget.task.xpPoints}',
                        'XP',
                        AppColors.xpPointsBg,
                        AppColors.xpPointsText,
                      ),
                      const Spacer(),
                      if (widget.task.status != TaskStatus.completed)
                        _buildStartQuestButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartQuestButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlueGlow.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _showQuestDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow, size: 16),
            const SizedBox(width: 5),
            Text(
              'START QUEST',
              style: AppTextStyles.buttonText.copyWith(
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryString(TaskCategory category) {
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
      default:
        return 'Unknown';
    }
  }

  Color _getBorderColor(TaskCategory category) {
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
      default:
        return AppColors.primaryBlue;
    }
  }

  Widget _buildCategoryIcon() {
    IconData iconData;
    Color iconColor;

    switch (widget.task.category) {
      case TaskCategory.strength:
        iconData = Icons.fitness_center;
        iconColor = AppColors.strengthColor;
        break;
      case TaskCategory.endurance:
        iconData = Icons.directions_run;
        iconColor = AppColors.enduranceColor;
        break;
      case TaskCategory.agility:
        iconData = Icons.flash_on;
        iconColor = AppColors.agilityColor;
        break;
      case TaskCategory.intelligence:
        iconData = Icons.psychology;
        iconColor = AppColors.intelligenceColor;
        break;
      case TaskCategory.discipline:
        iconData = Icons.access_time;
        iconColor = AppColors.disciplineColor;
        break;
      default:
        iconData = Icons.star;
        iconColor = AppColors.primaryBlue;
    }

    return Icon(iconData, color: iconColor, size: 18);
  }

  Widget _buildDifficultyIndicator() {
    Color color;
    String text;
    IconData iconData;

    switch (widget.task.difficulty) {
      case TaskDifficulty.easy:
        color = AppColors.easyDifficulty;
        text = 'EASY';
        iconData = Icons.sentiment_very_satisfied;
        break;
      case TaskDifficulty.medium:
        color = AppColors.mediumDifficulty;
        text = 'MEDIUM';
        iconData = Icons.sentiment_satisfied;
        break;
      case TaskDifficulty.hard:
        color = AppColors.hardDifficulty;
        text = 'HARD';
        iconData = Icons.sentiment_dissatisfied;
        break;
      case TaskDifficulty.extreme:
        color = AppColors.extremeDifficulty;
        text = 'EXTREME';
        iconData = Icons.whatshot;
        break;
      default:
        color = AppColors.easyDifficulty;
        text = 'EASY';
        iconData = Icons.sentiment_very_satisfied;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardChip(
    IconData icon,
    String value,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
