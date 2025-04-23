import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repositories.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, Tasks>> call(Tasks task) async {
    return await repository.updateTask(task);
  }
}