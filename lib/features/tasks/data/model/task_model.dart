
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
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      teamMembers: List<String>.from(json['team_members']),
      progress: json['progress'],
      subTasks: (json['sub_tasks'] as List)
          .map((subTask) => SubTaskModel.fromJson(subTask))
          .toList(),
      isCompleted: json['is_completed'],
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
      'sub_tasks': subTasks.map((subTask) => (subTask as SubTaskModel).toJson()).toList(),
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
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'],
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