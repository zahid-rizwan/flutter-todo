import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/task_model.dart';

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

  TaskRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    final response = await supabaseClient
        .from('tasks')
        .select('*, sub_tasks(*)')
        .eq('is_completed', true);
    return (response as List).map((e) => TaskModel.fromJson(e)).toList();
  }

  @override
  Future<List<TaskModel>> getOngoingTasks() async {
    final response = await supabaseClient
        .from('tasks')
        .select('*, sub_tasks(*)')
        .eq('is_completed', false);
    return (response as List).map((e) => TaskModel.fromJson(e)).toList();
  }

  @override
  Future<TaskModel> getTaskDetails(String taskId) async {
    final response = await supabaseClient
        .from('tasks')
        .select('*, sub_tasks(*)')
        .eq('id', taskId)
        .single();
    return TaskModel.fromJson(response);
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    final taskData = task.toJson();
    taskData['id'] = task.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : task.id;

    await supabaseClient.from('tasks').insert(taskData);

    for (final subtask in task.subTasks) {
      final subtaskData = (subtask as SubTaskModel).toJson();
      subtaskData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      subtaskData['task_id'] = taskData['id'];
      await supabaseClient.from('sub_tasks').insert(subtaskData);
    }

    return getTaskDetails(taskData['id']);
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final taskData = task.toJson();

    await supabaseClient
        .from('tasks')
        .update(taskData)
        .eq('id', task.id);

    await supabaseClient
        .from('sub_tasks')
        .delete()
        .eq('task_id', task.id);

    for (final subtask in task.subTasks) {
      final subtaskData = (subtask as SubTaskModel).toJson();
      subtaskData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      subtaskData['task_id'] = task.id;
      await supabaseClient.from('sub_tasks').insert(subtaskData);
    }

    return getTaskDetails(task.id);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await supabaseClient
        .from('sub_tasks')
        .delete()
        .eq('task_id', taskId);

    await supabaseClient
        .from('tasks')
        .delete()
        .eq('id', taskId);
  }
}