/// Task Model
///
/// Represents an individual To-Do task with a unique ID, description title,
/// completion status, and creation timestamp.
class Task {
  /// Unique identifier for the task, essential for Flutter keys (e.g. Dismissible)
  final String id;

  /// The text content or title describing the task
  String title;

  /// Tracks whether the task has been marked as finished
  bool isCompleted;

  /// Timestamp indicating when the task was created
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Toggles completion status between completed and incomplete
  void toggleCompleted() {
    isCompleted = !isCompleted;
  }
}
