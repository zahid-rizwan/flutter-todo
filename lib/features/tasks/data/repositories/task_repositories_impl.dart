

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domian/entities/task.dart';
import '../../domian/repositories/task_repositories.dart';
import '../datasources/task_local_datasources.dart';
import '../datasources/task_remote_datasources.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Tasks>>> getCompletedTasks() async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate fetching completed tasks
    try {
      final tasks = [
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

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Tasks>>> getOngoingTasks() async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate fetching ongoing tasks
    try {
      final tasks = [
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

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tasks>> getTaskDetails(String taskId) async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate fetching task details
    try {
      // Mock data based on task ID
      final task = Tasks(
        id: taskId,
        title: taskId == '3' ? 'Mobile App Wireframe' :
        taskId == '4' ? 'Real Estate App Design' :
        'Dashboard & App Design',
        description: taskId == '3' ?
        'Create wireframes for a new mobile app focused on task management. The app will include features for creating tasks, setting deadlines, assigning team members, and tracking progress.' :
        taskId == '4' ?
        'Design a real estate app for property listings and virtual tours. The app will allow users to search for properties, view details, schedule viewings, and contact agents.' :
        'Create a dashboard and app design for a project management tool. The dashboard will display project progress, team performance, and upcoming deadlines.',
        dueDate: taskId == '3' ?
        DateTime.now().add(const Duration(days: 21)) :
        taskId == '4' ?
        DateTime.now().add(const Duration(days: 60)) :
        DateTime.now().add(const Duration(days: 45)),
        teamMembers: ['John', 'Sarah', 'Mike'],
        progress: taskId == '3' ? 0.75 :
        taskId == '4' ? 0.6 :
        0.3,
        subTasks: taskId == '3' ?
        [
          SubTask(id: '3-1', title: 'User Research', isCompleted: true),
          SubTask(id: '3-2', title: 'Competitor Analysis', isCompleted: true),
          SubTask(id: '3-3', title: 'Wireframes', isCompleted: true),
          SubTask(id: '3-4', title: 'User Testing', isCompleted: false),
        ] :
        taskId == '4' ?
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

      return Right(task);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tasks>> addTask(Tasks task) async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate adding a task
    try {
      // In a real implementation, we would call the remote data source to add the task
      // and then update the local cache
      await Future.delayed(const Duration(seconds: 1));

      return Right(task);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tasks>> updateTask(Tasks task) async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate updating a task
    try {
      // In a real implementation, we would call the remote data source to update the task
      // and then update the local cache
      await Future.delayed(const Duration(seconds: 1));

      return Right(task);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    // This would normally check network connection and call the remote data source
    // For now, we'll simulate deleting a task
    try {
      // In a real implementation, we would call the remote data source to delete the task
      // and then update the local cache
      await Future.delayed(const Duration(seconds: 1));

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}