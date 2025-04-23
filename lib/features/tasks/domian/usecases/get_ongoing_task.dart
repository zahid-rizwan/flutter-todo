import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repositories.dart';

class GetOngoingTasks {
  final TaskRepository repository;

  GetOngoingTasks(this.repository);

  Future<Either<Failure, List<Tasks>>> call() async {
    return await repository.getOngoingTasks();
  }
}