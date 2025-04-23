import 'package:equatable/equatable.dart';

import '../../domian/entities/task.dart';

class TaskModel extends Tasks {
  const TaskModel({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required List<String> teamMembers,
    required double progress,
    required List<SubTask> subTasks,
    required bool isCompleted,
  }) : super(
    id: id,
    title: title,
    description: description,
    dueDate: dueDate,
    teamMembers: teamMembers,
    progress: progress,
    subTasks: subTasks,
    isCompleted: isCompleted,
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final subTasksData = json['sub_tasks'] as List? ?? [];
    final subTasks = subTasksData.map((subTaskData) => SubTaskModel.fromJson(subTaskData)).toList();

    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      dueDate: DateTime.parse(json['due_date']),
      teamMembers: List<String>.from(json['team_members'] ?? []),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      subTasks: subTasks,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'team_members': teamMembers,
      'progress': progress,
      'is_completed': isCompleted,
    };
  }

  factory TaskModel.fromEntity(Tasks task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      teamMembers: task.teamMembers,
      progress: task.progress,
      subTasks: task.subTasks.map((subTask) => SubTaskModel.fromEntity(subTask)).toList(),
      isCompleted: task.isCompleted,
    );
  }
}

class SubTaskModel extends SubTask {
  const SubTaskModel({
    required String id,
    required String title,
    required bool isCompleted,
  }) : super(
    id: id,
    title: title,
    isCompleted: isCompleted,
  );

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
    };
  }

  factory SubTaskModel.fromEntity(SubTask subTask) {
    return SubTaskModel(
      id: subTask.id,
      title: subTask.title,
      isCompleted: subTask.isCompleted,
    );
  }
}