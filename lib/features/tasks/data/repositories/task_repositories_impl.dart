import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domian/entities/task.dart';
import '../../domian/repositories/task_repositories.dart';
import '../datasources/task_local_datasources.dart';
import '../datasources/task_remote_datasources.dart';
import '../model/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final SupabaseClient supabaseClient;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.supabaseClient,
  });

  @override
  Future<Either<Failure, List<Tasks>>> getCompletedTasks() async {
    try {
      final response = await supabaseClient
          .from('tasks')
          .select('*, sub_tasks(*)')
          .eq('is_completed', true)
          .order('due_date', ascending: true);

      final tasks = (response as List)
          .map((taskData) => TaskModel.fromJson(taskData))
          .toList();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Tasks>>> getOngoingTasks() async {
    try {
      final response = await supabaseClient
          .from('tasks')
          .select('*, sub_tasks(*)')
          .eq('is_completed', false)
          .order('due_date', ascending: true);

      final tasks = (response as List)
          .map((taskData) => TaskModel.fromJson(taskData))
          .toList();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tasks>> getTaskDetails(String taskId) async {
    try {
      final response = await supabaseClient
          .from('tasks')
          .select('*, sub_tasks(*)')
          .eq('id', taskId)
          .single();

      final task = TaskModel.fromJson(response);
      return Right(task);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tasks>> addTask(Tasks task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final taskData = taskModel.toJson();
      taskData['id'] = task.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : task.id;

      // Insert task
      await supabaseClient.from('tasks').insert(taskData);

      // Insert subtasks
      for (final subtask in taskModel.subTasks) {
        final subtaskData = (subtask as SubTaskModel).toJson();
        subtaskData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
        subtaskData['task_id'] = taskData['id'];
        await supabaseClient.from('sub_tasks').insert(subtaskData);
      }

      // Return the newly created task
      final newTask = await getTaskDetails(taskData['id']);
      return newTask.fold(
            (failure) => Left(failure),
            (task) => Right(task),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tasks>> updateTask(Tasks task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final taskData = taskModel.toJson();

      // Update task
      await supabaseClient
          .from('tasks')
          .update(taskData)
          .eq('id', task.id);

      // Delete existing subtasks
      await supabaseClient
          .from('sub_tasks')
          .delete()
          .eq('task_id', task.id);

      // Insert updated subtasks
      for (final subtask in taskModel.subTasks) {
        final subtaskData = (subtask as SubTaskModel).toJson();
        subtaskData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
        subtaskData['task_id'] = task.id;
        await supabaseClient.from('sub_tasks').insert(subtaskData);
      }

      // Return the updated task
      final updatedTask = await getTaskDetails(task.id);
      return updatedTask.fold(
            (failure) => Left(failure),
            (task) => Right(task),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      // Delete subtasks first
      await supabaseClient
          .from('sub_tasks')
          .delete()
          .eq('task_id', taskId);

      // Delete task
      await supabaseClient
          .from('tasks')
          .delete()
          .eq('id', taskId);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}