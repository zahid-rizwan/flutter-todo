import 'package:equatable/equatable.dart';

class Tasks extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final List<String> teamMembers;
  final double progress;
  final List<SubTask> subTasks;
  final bool isCompleted;

  const Tasks({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.teamMembers,
    required this.progress,
    required this.subTasks,
    required this.isCompleted,
  });

  Tasks copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    List<String>? teamMembers,
    double? progress,
    List<SubTask>? subTasks,
    bool? isCompleted,
  }) {
    return Tasks(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      teamMembers: teamMembers ?? this.teamMembers,
      progress: progress ?? this.progress,
      subTasks: subTasks ?? this.subTasks,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    dueDate,
    teamMembers,
    progress,
    subTasks,
    isCompleted,
  ];
}

class SubTask extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const SubTask({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  SubTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted];
}