// components/tasks_list.dart
import 'package:flutter/material.dart';
import 'package:solo_fitness/app/data/models/task_model.dart';
import '../task_tile.dart';
import '../../../../data/theme/colors.dart';
import '../../../../data/theme/text_styles.dart';

class TasksList extends StatelessWidget {
  final List<TaskModel> tasks;
  final Function(String) onTaskCompleted;
  
  const TasksList({
    super.key, 
    required this.tasks,
    required this.onTaskCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return SliverFillRemaining(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 60,
                  color: AppColors.successGreen,
                ),
                const SizedBox(height: 16),
                Text(
                  'All quests completed!',
                  style: AppTextStyles.subtitleWhite,
                ),
                const SizedBox(height: 8),
                Text(
                  'Great job, Hunter. Return tomorrow for new quests.',
                  style: AppTextStyles.subtitleGrey,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final task = tasks[index];
            return TaskTile(
              task: task,
              onCompleted: () => onTaskCompleted(task.id),
            );
          },
          childCount: tasks.length,
        ),
      ),
    );
  }
}