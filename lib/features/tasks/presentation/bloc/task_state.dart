import 'package:equatable/equatable.dart';

import '../../domian/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<Tasks> completedTasks;
  final List<Tasks> ongoingTasks;

  const TaskLoadedState({
    required this.completedTasks,
    required this.ongoingTasks,
  });

  @override
  List<Object?> get props => [completedTasks, ongoingTasks];
}

class TaskErrorState extends TaskState {
  final String message;

  const TaskErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}