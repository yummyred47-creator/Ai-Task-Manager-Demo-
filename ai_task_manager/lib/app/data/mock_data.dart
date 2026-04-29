import 'package:flutter/material.dart';
import '../models/task_model.dart';

class MockData {
  static List<TaskModel> get tasks => [
    TaskModel(
      title: 'Design new landing page',
      description:
          'Create a modern, responsive landing page with hero section, features grid, and testimonials. Use the new brand guidelines.',
      priority: TaskPriority.high,
      category: TaskCategory.work,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      subTasks: [
        SubTask(title: 'Wireframe layout', isCompleted: true),
        SubTask(title: 'Design hero section', isCompleted: true),
        SubTask(title: 'Create feature cards', isCompleted: false),
        SubTask(title: 'Add animations', isCompleted: false),
      ],
      tags: ['design', 'urgent'],
    ),
    TaskModel(
      title: 'Prepare quarterly report',
      description:
          'Compile Q2 sales data, create charts, and write executive summary for the board meeting.',
      priority: TaskPriority.urgent,
      category: TaskCategory.work,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      subTasks: [
        SubTask(title: 'Gather sales data', isCompleted: true),
        SubTask(title: 'Create visualizations', isCompleted: true),
        SubTask(title: 'Write executive summary', isCompleted: false),
        SubTask(title: 'Review with manager', isCompleted: false),
        SubTask(title: 'Final formatting', isCompleted: false),
      ],
      tags: ['report', 'Q2'],
    ),
  ];

  static List<TaskModel> get archivedTasks => [
    TaskModel(
      title: 'Setup CI/CD pipeline',
      description:
          'Configure GitHub Actions for automated testing and deployment.',
      priority: TaskPriority.high,
      category: TaskCategory.work,
      isCompleted: true,
      isArchived: true,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      tags: ['devops'],
    ),
    TaskModel(
      title: 'Complete online course',
      description: 'Finish the UX Design Fundamentals course on Coursera.',
      priority: TaskPriority.medium,
      category: TaskCategory.study,
      isCompleted: true,
      isArchived: true,
      createdAt: DateTime.now().subtract(const Duration(days: 21)),
      tags: ['learning', 'ux'],
    ),
  ];

  static List<TaskModel> get trashedTasks => [
    TaskModel(
      title: 'Old meeting notes',
      description: 'Notes from the January planning meeting.',
      priority: TaskPriority.low,
      category: TaskCategory.work,
      isTrashed: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  static List<NotificationModel> get notifications => [
    NotificationModel(
      title: 'Task Due Soon',
      message: '"Prepare quarterly report" is due tomorrow.',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      icon: Icons.access_time_rounded,
      color: const Color(0xFFF5A623),
    ),
    NotificationModel(
      title: 'Task Completed',
      message: 'Great job! You completed "Morning yoga routine".',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.check_circle_outline_rounded,
      color: const Color(0xFF4CAF7D),
    ),
    NotificationModel(
      title: 'AI Suggestion',
      message:
          'Break "Design new landing page" into smaller sub-tasks for better focus.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF4A90D9),
    ),
    NotificationModel(
      title: 'Weekly Summary',
      message: 'You completed 12 tasks this week. Productivity up 15%!',
      time: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.insights_rounded,
      color: const Color(0xFFAB7BF0),
      isRead: true,
    ),
  ];
}
