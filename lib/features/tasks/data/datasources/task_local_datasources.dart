import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getCompletedTasks();
  Future<List<TaskModel>> getOngoingTasks();
  Future<TaskModel?> getTaskDetails(String taskId);
  Future<void> saveTask(TaskModel task);
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> deleteTask(String taskId);
  Future<List<TaskModel>> getCachedCompletedTasks();
  Future<List<TaskModel>> getCachedOngoingTasks();
  Future<void> cacheCompletedTasks(List<TaskModel> tasks);
  Future<void> cacheOngoingTasks(List<TaskModel> tasks);
}

const CACHED_TASKS_KEY = 'CACHED_TASKS';
const CACHED_COMPLETED_TASKS = 'CACHED_COMPLETED_TASKS';
const CACHED_ONGOING_TASKS = 'CACHED_ONGOING_TASKS';


class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    final jsonString = sharedPreferences.getString(CACHED_TASKS_KEY);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final tasks = jsonList
          .map((json) => TaskModel.fromJson(json))
          .where((task) => task.isCompleted)
          .toList();

      return tasks;
    }

    return [];
  }

  @override
  Future<List<TaskModel>> getOngoingTasks() async {
    final jsonString = sharedPreferences.getString(CACHED_TASKS_KEY);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final tasks = jsonList
          .map((json) => TaskModel.fromJson(json))
          .where((task) => !task.isCompleted)
          .toList();

      return tasks;
    }

    return [];
  }

  @override
  Future<TaskModel?> getTaskDetails(String taskId) async {
    final jsonString = sharedPreferences.getString(CACHED_TASKS_KEY);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final tasks = jsonList
          .map((json) => TaskModel.fromJson(json))
          .toList();

      return tasks.firstWhere(
            (task) => task.id == taskId,
        orElse: () => throw Exception('Task not found'),
      );
    }

    return null;
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final jsonString = sharedPreferences.getString(CACHED_TASKS_KEY);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final tasks = jsonList
          .map((json) => TaskModel.fromJson(json))
          .toList();

      final index = tasks.indexWhere((t) => t.id == task.id);

      if (index >= 0) {
        tasks[index] = task;
      } else {
        tasks.add(task);
      }

      await sharedPreferences.setString(
        CACHED_TASKS_KEY,
        json.encode(tasks.map((t) => t.toJson()).toList()),
      );
    } else {
      await sharedPreferences.setString(
        CACHED_TASKS_KEY,
        json.encode([task.toJson()]),
      );
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    await sharedPreferences.setString(
      CACHED_TASKS_KEY,
      json.encode(tasks.map((t) => t.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final jsonString = sharedPreferences.getString(CACHED_TASKS_KEY);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final tasks = jsonList
          .map((json) => TaskModel.fromJson(json))
          .toList();

      tasks.removeWhere((task) => task.id == taskId);

      await sharedPreferences.setString(
        CACHED_TASKS_KEY,
        json.encode(tasks.map((t) => t.toJson()).toList()),
      );
    }
  }
  @override
  Future<List<TaskModel>> getCachedCompletedTasks() async {
    final jsonString = sharedPreferences.getString(CACHED_COMPLETED_TASKS);
    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      return decodedJson.map((task) => TaskModel.fromJson(task)).toList();
    }
    return [];
  }

  @override
  Future<List<TaskModel>> getCachedOngoingTasks() async {
    final jsonString = sharedPreferences.getString(CACHED_ONGOING_TASKS);
    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      return decodedJson.map((task) => TaskModel.fromJson(task)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheCompletedTasks(List<TaskModel> tasks) async {
    final List<Map<String, dynamic>> tasksJson =
    tasks.map((task) => task.toJson()).toList();
    await sharedPreferences.setString(
      CACHED_COMPLETED_TASKS,
      json.encode(tasksJson),
    );
  }

  @override
  Future<void> cacheOngoingTasks(List<TaskModel> tasks) async {
    final List<Map<String, dynamic>> tasksJson =
    tasks.map((task) => task.toJson()).toList();
    await sharedPreferences.setString(
      CACHED_ONGOING_TASKS,
      json.encode(tasksJson),
    );
  }
}