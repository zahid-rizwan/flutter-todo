import 'package:dartz/dartz.dart';

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

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Tasks>>> getCompletedTasks() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTasks = await remoteDataSource.getCompletedTasks();
        localDataSource.cacheCompletedTasks(remoteTasks);
        return Right(remoteTasks);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localTasks = await localDataSource.getCachedCompletedTasks();
        return Right(localTasks);
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Tasks>>> getOngoingTasks() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTasks = await remoteDataSource.getOngoingTasks();
        localDataSource.cacheOngoingTasks(remoteTasks);
        return Right(remoteTasks);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localTasks = await localDataSource.getCachedOngoingTasks();
        return Right(localTasks);
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Tasks>> getTaskDetails(String taskId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTask = await remoteDataSource.getTaskDetails(taskId);
        return Right(remoteTask);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // We could look through cached tasks here, but for simplicity, return an error
      return Left(CacheFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, Tasks>> addTask(Tasks task) async {
    if (await networkInfo.isConnected) {
      try {
        final taskModel = TaskModel.fromEntity(task);
        final remoteTask = await remoteDataSource.addTask(taskModel);

        // Update the cache after adding a new task
        await _updateCacheAfterModification();

        return Right(remoteTask);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ServerFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, Tasks>> updateTask(Tasks task) async {
    if (await networkInfo.isConnected) {
      try {
        final taskModel = TaskModel.fromEntity(task);
        final remoteTask = await remoteDataSource.updateTask(taskModel);

        // Update the cache after updating a task
        await _updateCacheAfterModification();

        return Right(remoteTask);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ServerFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTask(taskId);

        // Update the cache after deleting a task
        await _updateCacheAfterModification();

        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ServerFailure(message: "No internet connection"));
    }
  }

  // Helper method to update the cache after task modification (add, update, delete)
  Future<void> _updateCacheAfterModification() async {
    try {
      final completedTasks = await remoteDataSource.getCompletedTasks();
      final ongoingTasks = await remoteDataSource.getOngoingTasks();

      await localDataSource.cacheCompletedTasks(completedTasks);
      await localDataSource.cacheOngoingTasks(ongoingTasks);
    } catch (e) {
      // Just log the error - this is a secondary operation
      print('Error updating cache: $e');
    }
  }
}