part of 'task_detail_bloc.dart';

abstract class TaskDetailState extends Equatable {
  const TaskDetailState();

  @override
  List<Object?> get props => [];
}

class TaskDetailInitialState extends TaskDetailState {}

class TaskDetailLoadingState extends TaskDetailState {}

class TaskDetailLoadedState extends TaskDetailState {
  final Tasks task;

  const TaskDetailLoadedState({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskDetailAddedState extends TaskDetailState {
  final Tasks task;

  const TaskDetailAddedState({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskDetailUpdatedState extends TaskDetailState {
  final Tasks task;

  const TaskDetailUpdatedState({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskDetailDeletedState extends TaskDetailState {
  final String taskId;

  const TaskDetailDeletedState({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class TaskDetailErrorState extends TaskDetailState {
  final String message;

  const TaskDetailErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}