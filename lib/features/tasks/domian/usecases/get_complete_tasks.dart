import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repositories.dart';

class GetCompletedTasks {
  final TaskRepository repository;

  GetCompletedTasks(this.repository);

  Future<Either<Failure, List<Tasks>>> call() async {
    return await repository.getCompletedTasks();
  }
}