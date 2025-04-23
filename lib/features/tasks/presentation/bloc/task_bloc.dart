import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_app_demo_1/features/tasks/presentation/bloc/task_event.dart';
import 'package:to_do_app_demo_1/features/tasks/presentation/bloc/task_state.dart';

import '../../domian/entities/task.dart';
import '../../domian/repositories/task_repositories.dart';
import '../../domian/usecases/get_complete_tasks.dart';
import '../../domian/usecases/get_ongoing_task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(TaskInitialState()) {
    on<LoadTasksEvent>(_onLoadTasks);
  }

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());

    try {
      final completedTasksResult = await repository.getCompletedTasks();
      final ongoingTasksResult = await repository.getOngoingTasks();

      completedTasksResult.fold(
            (failure) => emit(TaskErrorState(message: failure.message)),
            (completedTasks) {
          ongoingTasksResult.fold(
                (failure) => emit(TaskErrorState(message: failure.message)),
                (ongoingTasks) => emit(TaskLoadedState(
              completedTasks: completedTasks,
              ongoingTasks: ongoingTasks,
            )),
          );
        },
      );
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }
}