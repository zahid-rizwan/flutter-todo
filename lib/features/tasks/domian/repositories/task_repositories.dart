
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Tasks>>> getCompletedTasks();
  Future<Either<Failure, List<Tasks>>> getOngoingTasks();
  Future<Either<Failure, Tasks>> getTaskDetails(String taskId);
  Future<Either<Failure, Tasks>> addTask(Tasks task);
  Future<Either<Failure, Tasks>> updateTask(Tasks task);
  Future<Either<Failure, void>> deleteTask(String taskId);
}