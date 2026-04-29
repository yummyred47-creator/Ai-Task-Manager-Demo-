import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';

class SubTaskBreakdown {
  String title;
  String description;
  String timeEstimate;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController timeController;

  SubTaskBreakdown({
    required this.title,
    required this.description,
    required this.timeEstimate,
  }) : titleController = TextEditingController(text: title),
       descriptionController = TextEditingController(text: description),
       timeController = TextEditingController(text: timeEstimate);

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeController.dispose();
  }
}

class TaskBreakdownScreen extends StatefulWidget {
  final String taskDetails;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime? dueDate;

  const TaskBreakdownScreen({
    super.key,
    required this.taskDetails,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    this.dueDate,
  });

  @override
  State<TaskBreakdownScreen> createState() => _TaskBreakdownScreenState();
}

class _TaskBreakdownScreenState extends State<TaskBreakdownScreen> {
  late TextEditingController _taskNameController;
  final List<SubTaskBreakdown> _subTasks = [];

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.taskDetails);
    _initializeMockSubTasks();
  }

  void _initializeMockSubTasks() {
    _subTasks.addAll([
      SubTaskBreakdown(
        title: 'Research & Competitor Analysis',
        description:
            'Analyze top 3 competitors\' landing pages. Identify key value propositions and call-to-action strategies.',
        timeEstimate: '2 hours',
      ),
      SubTaskBreakdown(
        title: 'Wireframing & Layout',
        description:
            'Create low-fidelity wireframes for mobile and desktop views. Establish structural hierarchy.',
        timeEstimate: '3.5 hours',
      ),
      SubTaskBreakdown(
        title: 'Visual Design & Prototyping',
        description:
            'Apply brand guidelines, colors, and typography to wireframes. Create interactive prototype in Figma.',
        timeEstimate: '4 hours',
      ),
    ]);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    for (var subTask in _subTasks) {
      subTask.dispose();
    }
    super.dispose();
  }

  void _addSubTask() {
    setState(() {
      _subTasks.add(
        SubTaskBreakdown(title: '', description: '', timeEstimate: '1 hour'),
      );
    });
  }

  void _removeSubTask(int index) {
    setState(() {
      _subTasks[index].dispose();
      _subTasks.removeAt(index);
    });
  }

  void _handleAccept() {
    final lines = _taskNameController.text.trim().split('\n');
    final title = lines.first.trim();
    final description =
        lines.length > 1 ? lines.skip(1).join('\n').trim() : null;

    // Fix: ใช้ index ร่วมกับ timestamp เพื่อป้องกัน SubTask ID ชนกัน
    final baseTime = DateTime.now().millisecondsSinceEpoch;
    final subTasks =
        _subTasks.asMap().entries.map((entry) {
          final index = entry.key;
          final st = entry.value;
          return SubTask(
            id: '${baseTime}_$index',
            title: st.titleController.text.trim(),
            isCompleted: false,
          );
        }).toList();

    final task = TaskModel(
      title: title,
      description: description,
      priority: widget.priority,
      category: widget.category,
      dueDate: widget.dueDate,
      subTasks: subTasks,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(task);

    // Navigate ไป TaskDetailScreen พร้อม task ที่เพิ่งสร้าง
    // และ clear stack กลับไปที่ TaskListScreen (route แรก)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
      (route) => route.isFirst,
    );
  }

  void _handleEdit() {
    // Pop กลับไปหน้าก่อนหน้า (หน้าที่ user กรอกข้อมูล task)
    // เพื่อให้แก้ไข title / priority / category / dueDate ได้
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('TaskFlow'),
        actions: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  const SizedBox(height: 16),
                  const Text(
                    'Task Breakdown',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Review and refine the generated sub-tasks.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Task Input
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Task Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _taskNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // AI Note Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'You can edit yourself or press edit to let AI add/modify',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sub-tasks List
                  ..._subTasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final subTask = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSubTaskCard(index, subTask),
                    );
                  }),

                  // Add new subtask button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.border,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton.icon(
                      onPressed: _addSubTask,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subtask'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleEdit,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _handleAccept,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTaskCard(int index, SubTaskBreakdown subTask) {
    final isFirst = index == 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with number and title
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color:
                      isFirst
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          isFirst ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: subTask.titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => _removeSubTask(index),
                color: AppColors.textHint,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
          ),
          const SizedBox(height: 16),

          // Description and Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.subject,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: subTask.descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      maxLines: 4,
                      minLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: subTask.timeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: const Icon(
                          Icons.edit_calendar,
                          size: 18,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
