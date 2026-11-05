import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/planner_header.dart';
import '../widgets/responsive_container.dart';
import '../widgets/task_input_field.dart';
import '../widgets/task_summary_card.dart';
import '../widgets/task_tile.dart';

/// TodoHomeScreen (Personal Daily Planner)
///
/// Responsive Daily Planner screen supporting:
/// - Real-time Cloud Firestore synchronization across devices (laptop & mobile)
/// - Firebase Authentication user isolation
/// - Adding, completing (checkbox + strikethrough), swipe-to-delete with Undo
/// - Dynamic remaining task counter & completion progress
/// - Adaptive layout for mobile viewports and desktop browsers
class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();

  String get _currentUserId => _authService.currentUser?.uid ?? 'guest_user';

  /// Adds a new task to Cloud Firestore
  Future<void> _addNewTask(String title) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
      dueDate: DateTime.now(),
    );

    await _taskService.addTask(_currentUserId, newTask);

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task added: "$title"'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Toggles task completion in Cloud Firestore
  Future<void> _toggleTaskCompletion(Task task) async {
    await _taskService.toggleTask(_currentUserId, task);
  }

  /// Deletes a task from Cloud Firestore and offers an Undo option
  Future<void> _deleteTask(Task task, int originalIndex) async {
    await _taskService.deleteTask(_currentUserId, task.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${task.title}"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amberAccent,
          onPressed: () async {
            await _taskService.restoreTask(_currentUserId, task, originalIndex);
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Handles sign out
  Future<void> _handleSignOut() async {
    await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final isConfigured = DefaultFirebaseOptions.isConfigured;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ResponsiveContainer(
          maxWidth: 768,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Planner Header: Greeting, Date, User Account, Sign Out
              PlannerHeader(onSignOut: _handleSignOut),

              const SizedBox(height: 8),

              // Unconfigured Firebase Demo Banner (if credentials not yet set)
              if (!isConfigured)
                Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off_rounded, color: Colors.amber.shade800, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Demo Mode: Local memory active. Add your Firebase keys in lib/firebase_options.dart for real-time cloud sync.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Real-time Cloud Firestore Tasks Stream
              Expanded(
                child: StreamBuilder<List<Task>>(
                  stream: _taskService.getTasksStream(_currentUserId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading tasks: ${snapshot.error}',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      );
                    }

                    final tasks = snapshot.data ?? [];
                    final remainingTasksCount =
                        tasks.where((task) => !task.isCompleted).length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dynamic Summary Card
                        TaskSummaryCard(
                          totalTasks: tasks.length,
                          remainingTasks: remainingTasksCount,
                        ),

                        const SizedBox(height: 16),

                        // Input field and Add button with validation
                        TaskInputField(onAddTask: _addNewTask),

                        const SizedBox(height: 20),

                        // Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Today\'s Tasks (${tasks.length})',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            if (tasks.isNotEmpty)
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

                        // Tasks List or Empty State
                        Expanded(
                          child: tasks.isEmpty
                              ? const EmptyStateView()
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 24.0, top: 4.0),
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    final task = tasks[index];
                                    return TaskTile(
                                      task: task,
                                      onToggle: () => _toggleTaskCompletion(task),
                                      onDismissed: () => _deleteTask(task, index),
                                      onDeleteTap: () => _deleteTask(task, index),
                                    );
                                  },
                                ),
                        ),
                      ],
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
