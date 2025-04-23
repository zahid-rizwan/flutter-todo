import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../domian/entities/task.dart';

class SubtaskItem extends StatelessWidget {
  final SubTask subtask;
  final VoidCallback onToggle;

  const SubtaskItem({
    super.key,
    required this.subtask,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: subtask.isCompleted ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: subtask.isCompleted ? AppColors.primary : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: subtask.isCompleted
                  ? const Icon(
                Icons.check,
                size: 16,
                color: AppColors.darkBackground,
              )
                  : null,
            ),
          ),

          const SizedBox(width: 16),

          // Task title
          Expanded(
            child: Text(
              subtask.title,
              style: TextStyle(
                color: subtask.isCompleted ? AppColors.textSecondary : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}