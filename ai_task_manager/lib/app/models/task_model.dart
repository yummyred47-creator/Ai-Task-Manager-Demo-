import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum TaskPriority { low, medium, high, urgent }

enum TaskCategory { work, personal, health, shopping, study }

extension TaskPriorityExt on TaskPriority {
  String get label => switch (this) {
    TaskPriority.low => 'Low',
    TaskPriority.medium => 'Medium',
    TaskPriority.high => 'High',
    TaskPriority.urgent => 'Urgent',
  };

  Color get color => switch (this) {
    TaskPriority.low => const Color(0xFF4CAF7D),
    TaskPriority.medium => const Color(0xFF5BAFEB),
    TaskPriority.high => const Color(0xFFF5A623),
    TaskPriority.urgent => const Color(0xFFE85D5D),
  };

  IconData get icon => switch (this) {
    TaskPriority.low => Icons.arrow_downward_rounded,
    TaskPriority.medium => Icons.remove_rounded,
    TaskPriority.high => Icons.arrow_upward_rounded,
    TaskPriority.urgent => Icons.priority_high_rounded,
  };
}

extension TaskCategoryExt on TaskCategory {
  String get label => switch (this) {
    TaskCategory.work => 'Work',
    TaskCategory.personal => 'Personal',
    TaskCategory.health => 'Health',
    TaskCategory.shopping => 'Shopping',
    TaskCategory.study => 'Study',
  };

  Color get color => switch (this) {
    TaskCategory.work => const Color(0xFF5B8DEF),
    TaskCategory.personal => const Color(0xFFAB7BF0),
    TaskCategory.health => const Color(0xFF4CAF7D),
    TaskCategory.shopping => const Color(0xFFF5A623),
    TaskCategory.study => const Color(0xFFEF7B7B),
  };

  IconData get icon => switch (this) {
    TaskCategory.work => Icons.work_outline_rounded,
    TaskCategory.personal => Icons.person_outline_rounded,
    TaskCategory.health => Icons.favorite_outline_rounded,
    TaskCategory.shopping => Icons.shopping_bag_outlined,
    TaskCategory.study => Icons.school_outlined,
  };
}

class SubTask {
  final String id;
  final String title;
  bool isCompleted;

  SubTask({
    String? id,
    required this.title,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();
}

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime createdAt;
  final DateTime? dueDate;
  bool isCompleted;
  bool isArchived;
  bool isTrashed;
  final List<SubTask> subTasks;
  final List<String> tags;

  TaskModel({
    String? id,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    DateTime? createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.isArchived = false,
    this.isTrashed = false,
    List<SubTask>? subTasks,
    List<String>? tags,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        subTasks = subTasks ?? [],
        tags = tags ?? [];

  double get progress {
    if (subTasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    final completed = subTasks.where((s) => s.isCompleted).length;
    return completed / subTasks.length;
  }

  int get completedSubTasks => subTasks.where((s) => s.isCompleted).length;
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final IconData icon;
  final Color color;
  bool isRead;

  NotificationModel({
    String? id,
    required this.title,
    required this.message,
    required this.time,
    this.icon = Icons.notifications_outlined,
    this.color = const Color(0xFF4A90D9),
    this.isRead = false,
  }) : id = id ?? const Uuid().v4();
}
