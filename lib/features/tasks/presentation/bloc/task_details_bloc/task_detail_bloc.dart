import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domian/entities/task.dart';
import '../../../domian/usecases/add_task_details.dart';
import '../../../domian/usecases/delete_task.dart';
import '../../../domian/usecases/get_task_details.dart';
import '../../../domian/usecases/update_task.dart';

part 'task_detail_event.dart';
part 'task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final GetTaskDetails getTaskDetails;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  // Collection to store tasks
  final Map<String, Tasks> _tasksCollection = {};

  TaskDetailBloc({
    required this.getTaskDetails,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskDetailInitialState()) {
    on<GetTaskDetailsEvent>(_onGetTaskDetails);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onGetTaskDetails(GetTaskDetailsEvent event, Emitter<TaskDetailState> emit) async {
    emit(TaskDetailLoadingState());

    try {
      // Check if we already have this task in our collection
      if (_tasksCollection.containsKey(event.taskId)) {
        emit(TaskDetailLoadedState(task: _tasksCollection[event.taskId]!));
        return;
      }

      // This would normally call the use case
      // For now, we'll simulate fetching task details
      await Future.delayed(const Duration(seconds: 1));

      // Mock data based on task ID
      final task = Tasks(
        id: event.taskId,
        title: event.taskId == '3' ? 'Mobile App ' :
        event.taskId == '4' ? 'Real Estate App Design' :
        'Dashboard & App Design',
        description: event.taskId == '3' ?
        'Create wireframes for a new mobile app focused on task management. The app will include features for creating tasks, setting deadlines, assigning team members, and tracking progress.' :
        event.taskId == '4' ?
        'Design a real estate app for property listings and virtual tours. The app will allow users to search for properties, view details, schedule viewings, and contact agents.' :
        'Create a dashboard and app design for a project management tool. The dashboard will display project progress, team performance, and upcoming deadlines.',
        dueDate: event.taskId == '3' ?
        DateTime.now().add(const Duration(days: 21)) :
        event.taskId == '4' ?
        DateTime.now().add(const Duration(days: 60)) :
        DateTime.now().add(const Duration(days: 45)),
        teamMembers: ['John', 'Sarah', 'Mike'],
        progress: event.taskId == '3' ? 0.75 :
        event.taskId == '4' ? 0.6 :
        0.3,
        subTasks: event.taskId == '3' ?
        [
          SubTask(id: '3-1', title: 'User Research', isCompleted: true),
          SubTask(id: '3-2', title: 'Competitor Analysis', isCompleted: true),
          SubTask(id: '3-3', title: 'Wireframes', isCompleted: true),
          SubTask(id: '3-4', title: 'User Testing', isCompleted: false),
        ] :
        event.taskId == '4' ?
        [
          SubTask(id: '4-1', title: 'User Interviews', isCompleted: true),
          SubTask(id: '4-2', title: 'Wireframes', isCompleted: true),
          SubTask(id: '4-3', title: 'Design System', isCompleted: true),
          SubTask(id: '4-4', title: 'Icons', isCompleted: false),
          SubTask(id: '4-5', title: 'Final Mockups', isCompleted: false),
        ] :
        [
          SubTask(id: '5-1', title: 'Research', isCompleted: true),
          SubTask(id: '5-2', title: 'Wireframes', isCompleted: true),
          SubTask(id: '5-3', title: 'UI Design', isCompleted: false),
          SubTask(id: '5-4', title: 'Prototyping', isCompleted: false),
          SubTask(id: '5-5', title: 'User Testing', isCompleted: false),
        ],
        isCompleted: false,
      );

      // Store the task in our collection
      _tasksCollection[event.taskId] = task;

      emit(TaskDetailLoadedState(task: task));
    } catch (e) {
      emit(TaskDetailErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskDetailState> emit) async {
    emit(TaskDetailLoadingState());

    try {
      // This would normally call the use case
      // For now, we'll simulate adding a task
      await Future.delayed(const Duration(seconds: 1));

      // Add the task to our collection
      _tasksCollection[event.task.id] = event.task;

      emit(TaskDetailAddedState(task: event.task));
    } catch (e) {
      emit(TaskDetailErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskDetailState> emit) async {
    emit(TaskDetailLoadingState());

    try {
      // This would normally call the use case
      // For now, we'll simulate updating a task
      await Future.delayed(const Duration(seconds: 1));

      // Update the task in our collection
      _tasksCollection[event.task.id] = event.task;

      emit(TaskDetailUpdatedState(task: event.task));
      emit(TaskDetailLoadedState(task: event.task));
    } catch (e) {
      emit(TaskDetailErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskDetailState> emit) async {
    emit(TaskDetailLoadingState());

    try {
      // This would normally call the use case
      // For now, we'll simulate deleting a task
      await Future.delayed(const Duration(seconds: 1));

      // Remove the task from our collection
      _tasksCollection.remove(event.taskId);

      emit(TaskDetailDeletedState(taskId: event.taskId));
    } catch (e) {
      emit(TaskDetailErrorState(message: e.toString()));
    }
  }
}