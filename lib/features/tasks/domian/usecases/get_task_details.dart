import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repositories.dart';

class GetTaskDetails {
  final TaskRepository repository;

  GetTaskDetails(this.repository);

  Future<Either<Failure, Tasks>> call(String taskId) async {
    return await repository.getTaskDetails(taskId);
  }
}