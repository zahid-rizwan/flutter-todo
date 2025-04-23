import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app_demo_1/core/utils/snackbar_utils.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domian/entities/task.dart';
import '../bloc/task_details_bloc/task_detail_bloc.dart';
import '../widgets/subtask_item.dart';

class TaskDetailsPage extends StatefulWidget {
  final String taskId;

  const TaskDetailsPage({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadTaskDetails();
  }

  void _loadTaskDetails() {
    context.read<TaskDetailBloc>().add(
      GetTaskDetailsEvent(taskId: widget.taskId),
    );
  }

  void _deleteTask(Tasks task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Delete Task',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskDetailBloc>().add(
                DeleteTaskEvent(taskId: task.id),
              );
              context.go('/home');
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSubtaskStatus(Tasks task, SubTask subtask) {
    final updatedSubtasks = task.subTasks.map((s) {
      if (s.id == subtask.id) {
        return SubTask(
          id: s.id,
          title: s.title,
          isCompleted: !s.isCompleted,
        );
      }
      return s;
    }).toList();

    // Calculate new progress
    final completedCount = updatedSubtasks.where((s) => s.isCompleted).length;
    final newProgress = updatedSubtasks.isEmpty ? 0.0 : completedCount / updatedSubtasks.length;

    final updatedTask = task.copyWith(
      subTasks: updatedSubtasks,
      progress: newProgress,
      isCompleted: newProgress == 1.0,
    );

    context.read<TaskDetailBloc>().add(
      UpdateTaskEvent(task: updatedTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskDetailBloc, TaskDetailState>(
      listener: (context, state) {
        if (state is TaskDetailErrorState) {
          context.showErrorSnackBar(state.message);
        } else if (state is TaskDetailUpdatedState) {
          context.showSuccessSnackBar('Task updated successfully');
        }
      },
      builder: (context, state) {
        if (state is TaskDetailLoadingState) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            appBar: AppBar(
              title: const Text('Task Details'),
              backgroundColor: AppColors.darkBackground,
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        } else if (state is TaskDetailLoadedState) {
          final task = state.task;

          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            appBar: AppBar(
              title: const Text('Task Details'),
              backgroundColor: AppColors.darkBackground,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit task page
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task title
                  Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Due date and team
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: AppColors.darkBackground,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Date',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${task.dueDate.day} ${_getMonthName(task.dueDate.month)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.people,
                          color: AppColors.darkBackground,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Project Team',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 24,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: task.teamMembers.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.primaries[index % Colors.primaries.length],
                                    child: Text(
                                      task.teamMembers[index].substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Project details
                  const Text(
                    'Project Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    task.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Project progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Project Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: task.progress,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                              strokeWidth: 6,
                            ),
                          ),
                          Text(
                            '${(task.progress * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // All tasks
                  const Text(
                    'All Tasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtasks list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: task.subTasks.length,
                    itemBuilder: (context, index) {
                      final subtask = task.subTasks[index];
                      return SubtaskItem(
                        subtask: subtask,
                        onToggle: () => _toggleSubtaskStatus(task, subtask),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Add task button
                  AppButton(
                    text: 'Add Task',
                    onPressed: () {
                      // Show dialog to add new subtask
                      _showAddSubtaskDialog(context, task);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Delete task button
                  AppButton(
                    text: 'Delete Project',
                    type: AppButtonType.secondary,
                    onPressed: () => _deleteTask(task),
                  ),
                ],
              ),
            ),
          );
        } else if (state is TaskDetailErrorState) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            appBar: AppBar(
              title: const Text('Task Details'),
              backgroundColor: AppColors.darkBackground,
              elevation: 0,
            ),
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: AppColors.error,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: const Text('Task Details'),
            backgroundColor: AppColors.darkBackground,
            elevation: 0,
          ),
          body: const Center(
            child: Text(
              'No task details available',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddSubtaskDialog(BuildContext context, Tasks task) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Add New Task',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter task name',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final newSubtask = SubTask(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: controller.text,
                  isCompleted: false,
                );

                final updatedSubtasks = [...task.subTasks, newSubtask];

                // Calculate new progress
                final completedCount = updatedSubtasks.where((s) => s.isCompleted).length;
                final newProgress = updatedSubtasks.isEmpty ? 0.0 : completedCount / updatedSubtasks.length;

                final updatedTask = task.copyWith(
                  subTasks: updatedSubtasks,
                  progress: newProgress,
                );

                context.read<TaskDetailBloc>().add(
                  UpdateTaskEvent(task: updatedTask),
                );

                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}