
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


  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    await Future.delayed(const Duration(seconds: 1));

    return [];
  }

  @override
  Future<List<TaskModel>> getOngoingTasks() async {
    await Future.delayed(const Duration(seconds: 1));

    return [];
  }

  @override
  Future<TaskModel> getTaskDetails(String taskId) async {

    await Future.delayed(const Duration(seconds: 1));
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {

    await Future.delayed(const Duration(seconds: 1));

    return task;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {

    await Future.delayed(const Duration(seconds: 1));

    return task;
  }

  @override
  Future<void> deleteTask(String taskId) async {

    await Future.delayed(const Duration(seconds: 1));

    return;
  }
}