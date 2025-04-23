import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/task_repositories.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, void>> call(String taskId) async {
    return await repository.deleteTask(taskId);
  }
}