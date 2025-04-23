import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_demo_1/core/utils/snackbar_utils.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domian/entities/task.dart';
import '../bloc/task_details_bloc/task_detail_bloc.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  final List<String> _teamMembers = ['John', 'Sarah', 'Mike'];
  final List<SubTask> _subtasks = [];
  final _subtaskController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.darkBackground,
              surface: AppColors.cardBackground,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.darkBackground,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  // void _addSubtask() {  {
  //   setState(() {
  //     _dueDate = picked;
  //   });
  // }
  // }

  void _addSubtask() {
    if (_subtaskController.text.isEmpty) return;

    setState(() {
      _subtasks.add(
        SubTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _subtaskController.text,
          isCompleted: false,
        ),
      );
      _subtaskController.clear();
    });
  }

  void _removeSubtask(String id) {
    setState(() {
      _subtasks.removeWhere((subtask) => subtask.id == id);
    });
  }

  void _createTask() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_subtasks.isEmpty) {
        context.showWarningSnackBar('Please add at least one task');
        return;
      }

      final task = Tasks(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        teamMembers: _teamMembers,
        progress: 0.0,
        subTasks: _subtasks,
        isCompleted: false,
      );

      context.read<TaskDetailBloc>().add(AddTaskEvent(task: task));
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Add Task',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      body: BlocListener<TaskDetailBloc, TaskDetailState>(
        listener: (context, state) {
          if (state is TaskDetailErrorState) {
            context.showErrorSnackBar(state.message);
          } else if (state is TaskDetailAddedState) {
            context.showSuccessSnackBar('Task added successfully');
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                AppTextField(
                  label: 'Task Title',
                  hint: "Enter the task title",
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Description field
                AppTextField(
                  label: 'Description',
                  hint: "Enter description",
                  controller: _descriptionController,
                  maxLines: 5,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Due date picker
                const Text(
                  'Due Date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd MMMM, yyyy').format(_dueDate),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Team members
                const Text(
                  'Team Members',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      for (int i = 0; i < _teamMembers.length; i++)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.primaries[i % Colors.primaries.length],
                            child: Text(
                              _teamMembers[i].substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          // Show dialog to add team member
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Subtasks
                const Text(
                  'Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                // Add subtask field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _subtaskController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Add a task',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.primary,
                        size: 40,
                      ),
                      onPressed: _addSubtask,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Subtasks list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _subtasks.length,
                  itemBuilder: (context, index) {
                    final subtask = _subtasks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: AppColors.textSecondary,
                            size: 12,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              subtask.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                            onPressed: () => _removeSubtask(subtask.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Create task button
                AppButton(
                  text: 'Create Task',
                  onPressed: _createTask,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}