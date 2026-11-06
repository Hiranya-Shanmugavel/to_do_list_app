import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import '../models/task.dart';

/// Task Service
///
/// Handles Cloud Firestore real-time synchronization under:
/// `/users/{userId}/tasks/{taskId}`
/// Provides dynamic multi-device sync across laptop and mobile devices.
class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;

  FirebaseFirestore? get _firestore {
    if (DefaultFirebaseOptions.isConfigured && Firebase.apps.isNotEmpty) {
      try {
        return FirebaseFirestore.instance;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // In-memory fallback list for testing or unconfigured demo mode
  final List<Task> _mockTasks = [
    Task(
      id: '1',
      title: 'Plan today\'s priority goals 🎯',
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'Review daily calendar and agenda 📅',
      isCompleted: true,
    ),
    Task(
      id: '3',
      title: 'Swipe left/right to dismiss completed items',
      isCompleted: false,
    ),
  ];
  late final StreamController<List<Task>> _mockTasksController;

  TaskService._internal() {
    _mockTasksController = StreamController<List<Task>>.broadcast(
      onListen: () {
        _mockTasksController.add(List.unmodifiable(_mockTasks));
      },
    );
  }

  /// Reference to the user-scoped Firestore subcollection: /users/{userId}/tasks
  CollectionReference<Map<String, dynamic>>? _userTasksRef(String userId) {
    final firestore = _firestore;
    if (firestore == null) return null;
    return firestore.collection('users').doc(userId).collection('tasks');
  }

  /// Real-time stream of tasks for the logged in user
  Stream<List<Task>> getTasksStream(String userId) {
    final tasksRef = _userTasksRef(userId);
    if (tasksRef != null && userId.isNotEmpty) {
      return tasksRef
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Task.fromMap(doc.id, doc.data());
        }).toList();
      });
    }

    return _mockTasksController.stream;
  }

  /// Adds a new task to Firestore
  Future<void> addTask(String userId, Task task) async {
    final tasksRef = _userTasksRef(userId);
    if (tasksRef != null && userId.isNotEmpty) {
      await tasksRef.doc(task.id).set(task.toMap());
      return;
    }

    _mockTasks.insert(0, task);
    _mockTasksController.add(List.unmodifiable(_mockTasks));
  }

  /// Updates task completion status
  Future<void> toggleTask(String userId, Task task) async {
    final tasksRef = _userTasksRef(userId);
    if (tasksRef != null && userId.isNotEmpty) {
      await tasksRef.doc(task.id).update({
        'isCompleted': !task.isCompleted,
      });
      return;
    }

    final index = _mockTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _mockTasks[index].toggleCompleted();
      _mockTasksController.add(List.unmodifiable(_mockTasks));
    }
  }

  /// Deletes a task from Firestore
  Future<void> deleteTask(String userId, String taskId) async {
    final tasksRef = _userTasksRef(userId);
    if (tasksRef != null && userId.isNotEmpty) {
      await tasksRef.doc(taskId).delete();
      return;
    }

    _mockTasks.removeWhere((t) => t.id == taskId);
    _mockTasksController.add(List.unmodifiable(_mockTasks));
  }

  /// Restores a deleted task (Undo functionality)
  Future<void> restoreTask(String userId, Task task, int? index) async {
    final tasksRef = _userTasksRef(userId);
    if (tasksRef != null && userId.isNotEmpty) {
      await tasksRef.doc(task.id).set(task.toMap());
      return;
    }

    if (index != null && index >= 0 && index <= _mockTasks.length) {
      _mockTasks.insert(index, task);
    } else {
      _mockTasks.add(task);
    }
    _mockTasksController.add(List.unmodifiable(_mockTasks));
  }
}
