/// Task Model
///
/// Represents an individual To-Do / Daily Planner task with a unique ID,
/// title, completion status, creation timestamp, optional due date, and priority.
class Task {
  /// Unique identifier for the task (document ID in Firestore or local UUID)
  final String id;

  /// The text content or title describing the task
  String title;

  /// Tracks whether the task has been marked as completed
  bool isCompleted;

  /// Timestamp indicating when the task was created
  final DateTime createdAt;

  /// Optional due date for the daily planner
  final DateTime? dueDate;

  /// Priority of the task ('Normal', 'High', 'Low')
  final String priority;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
    this.dueDate,
    this.priority = 'Normal',
  }) : createdAt = createdAt ?? DateTime.now();

  /// Toggles completion status between completed and incomplete
  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  /// Converts the Task into a Map for Cloud Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
    };
  }

  /// Creates a Task instance from a Firestore document map
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val == null) return DateTime.now();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      // Gracefully handles Firestore Timestamp objects if returned by SDK
      try {
        return (val as dynamic).toDate();
      } catch (_) {
        return DateTime.now();
      }
    }

    DateTime? parseNullableDate(dynamic val) {
      if (val == null) return null;
      if (val is String) return DateTime.tryParse(val);
      try {
        return (val as dynamic).toDate();
      } catch (_) {
        return null;
      }
    }

    return Task(
      id: id,
      title: map['title'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: parseDate(map['createdAt']),
      dueDate: parseNullableDate(map['dueDate']),
      priority: map['priority'] as String? ?? 'Normal',
    );
  }

  /// Creates a copy of this Task with optional updated fields
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}
