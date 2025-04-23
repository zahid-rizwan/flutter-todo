part of 'task_detail_bloc.dart';

abstract class TaskDetailEvent extends Equatable {
  const TaskDetailEvent();

  @override
  List<Object?> get props => [];
}

class GetTaskDetailsEvent extends TaskDetailEvent {
  final String taskId;

  const GetTaskDetailsEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class AddTaskEvent extends TaskDetailEvent {
  final Tasks task;

  const AddTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskDetailEvent {
  final Tasks task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskDetailEvent {
  final String taskId;

  const DeleteTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
