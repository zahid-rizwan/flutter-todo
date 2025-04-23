
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
  // This would normally use Supabase client
  // For now, we'll just implement the methods with mock data

  @override
  Future<List<TaskModel>> getCompletedTasks() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data would be returned here
    return [];
  }

  @override
  Future<List<TaskModel>> getOngoingTasks() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data would be returned here
    return [];
  }

  @override
  Future<TaskModel> getTaskDetails(String taskId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data would be returned here
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data would be returned here
    return task;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data would be returned here
    return task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return;
  }
}