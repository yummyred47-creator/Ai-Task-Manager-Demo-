import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../data/mock_data.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<NotificationModel> _notifications = [];

  TaskProvider() {
    _initializeData();
  }

  void _initializeData() {
    _tasks = MockData.tasks;
    _notifications = MockData.notifications;
  }

  // Getters
  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get activeTasks =>
      _tasks.where((t) => !t.isArchived && !t.isTrashed).toList();
  List<TaskModel> get archivedTasks =>
      _tasks.where((t) => t.isArchived).toList();
  List<TaskModel> get trashedTasks => _tasks.where((t) => t.isTrashed).toList();
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  // Task operations
  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(TaskModel updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final newValue = !_tasks[index].isCompleted;
      _tasks[index].isCompleted = newValue;
      // When main task is checked, check all sub-tasks
      if (newValue && _tasks[index].subTasks.isNotEmpty) {
        for (var subTask in _tasks[index].subTasks) {
          subTask.isCompleted = true;
        }
      }
      notifyListeners();
    }
  }

  void completeAndArchiveTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].isCompleted = true;
      _tasks[index].isArchived = true;
      _tasks[index].isTrashed = false;
      notifyListeners();
    }
  }

  void toggleSubTaskCompletion(String taskId, String subTaskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final subTaskIndex = _tasks[index].subTasks.indexWhere(
        (s) => s.id == subTaskId,
      );
      if (subTaskIndex != -1) {
        _tasks[index].subTasks[subTaskIndex].isCompleted =
            !_tasks[index].subTasks[subTaskIndex].isCompleted;
        // Check if all sub-tasks are now completed, then check main task
        final allCompleted = _tasks[index].subTasks.every((s) => s.isCompleted);
        if (allCompleted) {
          _tasks[index].isCompleted = true;
        } else if (_tasks[index].isCompleted) {
          // If main was checked but not all sub-tasks are, uncheck main
          _tasks[index].isCompleted = false;
        }
        notifyListeners();
      }
    }
  }

  void archiveTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].isArchived = true;
      _tasks[index].isTrashed = false;
      notifyListeners();
    }
  }

  void unarchiveTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].isArchived = false;
      notifyListeners();
    }
  }

  void trashTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].isTrashed = true;
      _tasks[index].isArchived = false;
      notifyListeners();
    }
  }

  void restoreTask(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].isTrashed = false;
      notifyListeners();
    }
  }

  void permanentlyDeleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  // Filter tasks by category
  List<TaskModel> getTasksByCategory(TaskCategory category) {
    return activeTasks.where((t) => t.category == category).toList();
  }

  // Filter tasks by priority
  List<TaskModel> getTasksByPriority(TaskPriority priority) {
    return activeTasks.where((t) => t.priority == priority).toList();
  }

  // Get tasks due today
  List<TaskModel> getTasksDueToday() {
    final now = DateTime.now();
    return activeTasks
        .where(
          (t) =>
              t.dueDate != null &&
              t.dueDate!.day == now.day &&
              t.dueDate!.month == now.month &&
              t.dueDate!.year == now.year,
        )
        .toList();
  }

  // Get completed tasks today
  List<TaskModel> getCompletedTasksToday() {
    final now = DateTime.now();
    return activeTasks
        .where(
          (t) =>
              t.isCompleted &&
              t.dueDate != null &&
              t.dueDate!.day == now.day &&
              t.dueDate!.month == now.month &&
              t.dueDate!.year == now.year,
        )
        .toList();
  }

  // Notification operations
  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  // Statistics
  int get totalTasks => activeTasks.length;
  int get completedTasks => activeTasks.where((t) => t.isCompleted).length;
  int get pendingTasks => activeTasks.where((t) => !t.isCompleted).length;
  double get completionRate =>
      totalTasks > 0 ? completedTasks / totalTasks : 0.0;
}
