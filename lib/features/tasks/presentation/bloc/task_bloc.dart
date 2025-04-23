import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do_app_demo_1/features/tasks/presentation/bloc/task_event.dart';
import 'package:to_do_app_demo_1/features/tasks/presentation/bloc/task_state.dart';

import '../../domian/entities/task.dart';
import '../../domian/usecases/get_complete_tasks.dart';
import '../../domian/usecases/get_ongoing_task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetCompletedTasks getCompletedTasks;
  final GetOngoingTasks getOngoingTasks;

  TaskBloc({
    required this.getCompletedTasks,
    required this.getOngoingTasks,
  }) : super(TaskInitialState()) {
    on<LoadTasksEvent>(_onLoadTasks);
  }

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());

    try {
      // This would normally call the use cases
      // For now, we'll simulate fetching tasks
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final completedTasks = [
        Tasks(
          id: '1',
          title: 'Real Estate Website Design',
          description: 'Design a modern real estate website with property listings and search functionality.',
          dueDate: DateTime.now().subtract(const Duration(days: 10)),
          teamMembers: ['John', 'Sarah', 'Mike', 'Lisa', 'Tom'],
          progress: 1.0,
          subTasks: [
            SubTask(id: '1-1', title: 'Wireframes', isCompleted: true),
            SubTask(id: '1-2', title: 'UI Design', isCompleted: true),
            SubTask(id: '1-3', title: 'Frontend Development', isCompleted: true),
          ],
          isCompleted: true,
        ),
        Tasks(
          id: '2',
          title: 'Finance Mobile App Design',
          description: 'Design a finance tracking mobile app with budget management features.',
          dueDate: DateTime.now().subtract(const Duration(days: 5)),
          teamMembers: ['John', 'Sarah', 'Mike', 'Lisa', 'Tom'],
          progress: 1.0,
          subTasks: [
            SubTask(id: '2-1', title: 'User Research', isCompleted: true),
            SubTask(id: '2-2', title: 'Wireframes', isCompleted: true),
            SubTask(id: '2-3', title: 'UI Design', isCompleted: true),
          ],
          isCompleted: true,
        ),
      ];

      final ongoingTasks = [
        Tasks(
          id: '3',
          title: 'Mobile App Wireframe',
          description: 'Create wireframes for a new mobile app focused on task management.',
          dueDate: DateTime.now().add(const Duration(days: 21)),
          teamMembers: ['John', 'Sarah', 'Mike'],
          progress: 0.75,
          subTasks: [
            SubTask(id: '3-1', title: 'User Research', isCompleted: true),
            SubTask(id: '3-2', title: 'Competitor Analysis', isCompleted: true),
            SubTask(id: '3-3', title: 'Wireframes', isCompleted: true),
            SubTask(id: '3-4', title: 'User Testing', isCompleted: false),
          ],
          isCompleted: false,
        ),
        Tasks(
          id: '4',
          title: 'Real Estate App Design',
          description: 'Design a real estate app for property listings and virtual tours.',
          dueDate: DateTime.now().add(const Duration(days: 60)),
          teamMembers: ['John', 'Sarah', 'Mike'],
          progress: 0.6,
          subTasks: [
            SubTask(id: '4-1', title: 'User Interviews', isCompleted: true),
            SubTask(id: '4-2', title: 'Wireframes', isCompleted: true),
            SubTask(id: '4-3', title: 'Design System', isCompleted: true),
            SubTask(id: '4-4', title: 'Icons', isCompleted: false),
            SubTask(id: '4-5', title: 'Final Mockups', isCompleted: false),
          ],
          isCompleted: false,
        ),
        Tasks(
          id: '5',
          title: 'Dashboard & App Design',
          description: 'Create a dashboard and app design for a project management tool.',
          dueDate: DateTime.now().add(const Duration(days: 45)),
          teamMembers: ['John', 'Sarah', 'Mike'],
          progress: 0.3,
          subTasks: [
            SubTask(id: '5-1', title: 'Research', isCompleted: true),
            SubTask(id: '5-2', title: 'Wireframes', isCompleted: true),
            SubTask(id: '5-3', title: 'UI Design', isCompleted: false),
            SubTask(id: '5-4', title: 'Prototyping', isCompleted: false),
            SubTask(id: '5-5', title: 'User Testing', isCompleted: false),
          ],
          isCompleted: false,
        ),
      ];

      emit(TaskLoadedState(
        completedTasks: completedTasks,
        ongoingTasks: ongoingTasks,
      ));
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }
}