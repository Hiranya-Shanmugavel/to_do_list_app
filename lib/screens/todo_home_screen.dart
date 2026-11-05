import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/task_input_field.dart';
import '../widgets/task_summary_card.dart';
import '../widgets/task_tile.dart';

/// TodoHomeScreen
///
/// Main screen of the application built as a StatefulWidget (Requirement 10).
/// It manages the state of tasks: adding, completing, deleting, and calculating
/// the dynamic remaining task count.
class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  /// In-memory list holding the task items
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Welcome to your To-Do App! 👋',
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'Tap the checkbox to mark as complete',
      isCompleted: true,
    ),
    Task(
      id: '3',
      title: 'Swipe left or right on this task to delete it',
      isCompleted: false,
    ),
  ];

  /// Dynamically computes the count of remaining incomplete tasks (Requirement 8)
  int get remainingTasksCount =>
      _tasks.where((task) => !task.isCompleted).length;

  /// Adds a new task to the top of the list (Requirements 2, 3)
  void _addNewTask(String title) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
    );

    setState(() {
      _tasks.insert(0, newTask);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task added: "$title"'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Toggles the completion status of a task (Requirements 5, 6)
  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.toggleCompleted();
    });
  }

  /// Deletes a task and shows an Undo SnackBar (Requirement 7)
  void _deleteTask(Task task) {
    final originalIndex = _tasks.indexOf(task);
    if (originalIndex == -1) return;

    setState(() {
      _tasks.removeAt(originalIndex);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${task.title}"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amberAccent,
          onPressed: () {
            setState(() {
              _tasks.insert(originalIndex, task);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Shows an informational dialog about the project
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.task_alt_rounded, color: Color(0xFF4F46E5)),
            SizedBox(width: 10),
            Text('InternCircle Project 03'),
          ],
        ),
        content: const Text(
          'To-Do List Application\n\n'
          'Features:\n'
          '• Add tasks with validation\n'
          '• Mark complete with checkbox & strikethrough\n'
          '• Swipe left/right using Dismissible to delete\n'
          '• Dynamic remaining tasks tracker\n'
          '• Responsive and modern Flutter UI',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 26),
            SizedBox(width: 10),
            Text(
              'My Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'About Project',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card displaying dynamic remaining tasks count (Requirement 8)
              TaskSummaryCard(
                totalTasks: _tasks.length,
                remainingTasks: remainingTasksCount,
              ),

              const SizedBox(height: 16),

              // Input field and Add button with empty input validation (Requirements 2, 3, 12)
              TaskInputField(
                onAddTask: _addNewTask,
              ),

              const SizedBox(height: 20),

              // Tasks Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks (${_tasks.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  if (_tasks.isNotEmpty)
                    Text(
                      'Swipe left/right to delete',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Display tasks using ListView.builder (Requirement 4)
              // or Friendly Empty State when empty (Requirement 9)
              Expanded(
                child: _tasks.isEmpty
                    ? const EmptyStateView()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24.0, top: 4.0),
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return TaskTile(
                            task: task,
                            onToggle: () => _toggleTaskCompletion(task),
                            onDismissed: () => _deleteTask(task),
                            onDeleteTap: () => _deleteTask(task),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
