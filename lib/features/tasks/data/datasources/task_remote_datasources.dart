import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../model/task_model.dart';
import 'package:flutter/material.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getCompletedTasks();
  Future<List<TaskModel>> getOngoingTasks();
  Future<TaskModel> getTaskDetails(String taskId);
  Future<TaskModel> addTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final SupabaseClient supabaseClient;
  static const String _tasksTable = 'tasks';
  static const String _subTasksTable = 'sub_tasks';

  TaskRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    try {
      final response = await supabaseClient
          .from(_tasksTable)
          .select('*, $_subTasksTable(*)')
          .eq('is_completed', true);

      final data = response as List;
      return data.map((taskData) => _mapToTaskModel(taskData)).toList();
    } catch (e) {
      debugPrint('Error getting completed tasks: $e');
      throw Exception('Failed to get completed tasks: $e');
    }
  }

  @override
  Future<List<TaskModel>> getOngoingTasks() async {
    try {
      final response = await supabaseClient
          .from(_tasksTable)
          .select('*, $_subTasksTable(*)')
          .eq('is_completed', false);

      final data = response as List;
      return data.map((taskData) => _mapToTaskModel(taskData)).toList();
    } catch (e) {
      debugPrint('Error getting ongoing tasks: $e');
      throw Exception('Failed to get ongoing tasks: $e');
    }
  }

  @override
  Future<TaskModel> getTaskDetails(String taskId) async {
    try {
      final response = await supabaseClient
          .from(_tasksTable)
          .select('*, $_subTasksTable(*)')
          .eq('id', taskId)
          .single();

      return _mapToTaskModel(response);
    } catch (e) {
      debugPrint('Error getting task details: $e');
      throw Exception('Failed to get task details: $e');
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    try {
      // Generate a UUID if not provided
      final taskId = task.id.isEmpty ? const Uuid().v4() : task.id;
      final taskWithId = task.copyWith(id: taskId) as TaskModel;

      // Insert task data
      await supabaseClient
          .from(_tasksTable)
          .insert(_prepareTaskData(taskWithId));

      // Insert subtasks with references to the parent task
      for (var subTask in taskWithId.subTasks) {
        await supabaseClient
            .from(_subTasksTable)
            .insert({
          'id': subTask.id.isEmpty ? const Uuid().v4() : subTask.id,
          'title': subTask.title,
          'is_completed': subTask.isCompleted,
          'task_id': taskId,
        });
      }

      // Return the added task with complete details
      return getTaskDetails(taskId);
    } catch (e) {
      debugPrint('Error adding task: $e');
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      // Update task data
      await supabaseClient
          .from(_tasksTable)
          .update(_prepareTaskData(task))
          .eq('id', task.id);

      // For subtasks, we'll delete existing ones and recreate them
      // First delete existing subtasks
      await supabaseClient
          .from(_subTasksTable)
          .delete()
          .eq('task_id', task.id);

      // Now insert the updated subtasks
      for (var subTask in task.subTasks) {
        await supabaseClient
            .from(_subTasksTable)
            .insert({
          'id': subTask.id.isEmpty ? const Uuid().v4() : subTask.id,
          'title': subTask.title,
          'is_completed': subTask.isCompleted,
          'task_id': task.id,
        });
      }

      // Return the updated task with complete details
      return getTaskDetails(task.id);
    } catch (e) {
      debugPrint('Error updating task: $e');
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      // Delete subtasks first (assuming cascade delete is not set up)
      await supabaseClient
          .from(_subTasksTable)
          .delete()
          .eq('task_id', taskId);

      // Delete the task
      await supabaseClient
          .from(_tasksTable)
          .delete()
          .eq('id', taskId);
    } catch (e) {
      debugPrint('Error deleting task: $e');
      throw Exception('Failed to delete task: $e');
    }
  }

  // Helper method to map Supabase response to TaskModel
  TaskModel _mapToTaskModel(Map<String, dynamic> data) {
    final subTasksData = data['sub_tasks'] as List;
    final subTasks = subTasksData.map((subTaskData) => SubTaskModel(
      id: subTaskData['id'],
      title: subTaskData['title'],
      isCompleted: subTaskData['is_completed'],
    )).toList();

    return TaskModel(
      id: data['id'],
      title: data['title'],
      description: data['description'] ?? '',
      dueDate: DateTime.parse(data['due_date']),
      teamMembers: List<String>.from(data['team_members']),
      progress: data['progress'] is int
          ? (data['progress'] as int).toDouble()
          : data['progress'],
      subTasks: subTasks,
      isCompleted: data['is_completed'],
    );
  }

  // Helper method to prepare task data for Supabase
  Map<String, dynamic> _prepareTaskData(TaskModel task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'due_date': task.dueDate.toIso8601String(),
      'team_members': task.teamMembers,
      'progress': task.progress,
      'is_completed': task.isCompleted,
    };
  }
}