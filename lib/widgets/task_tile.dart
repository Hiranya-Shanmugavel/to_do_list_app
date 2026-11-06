import 'package:flutter/material.dart';
import '../models/task.dart';

/// TaskTile Widget
///
/// Displays a single task item inside a Dismissible card.
/// Supports:
/// - Swipe left or right to delete (Requirement 7)
/// - Checkbox toggle for completion (Requirement 5)
/// - Strikethrough decoration for completed tasks (Requirement 6)
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDismissed;
  final VoidCallback onDeleteTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDismissed,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = task.isCompleted;

    // Helper to build swipe-to-delete background
    Widget buildDismissBackground({required Alignment alignment}) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: alignment,
        decoration: BoxDecoration(
          color: Colors.redAccent.shade200,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 26),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Dismissible(
      // Each Dismissible must have a unique Key (Requirement 7)
      key: ValueKey(task.id),
      direction: DismissDirection.horizontal, // Swipe both left and right
      background: buildDismissBackground(alignment: Alignment.centerLeft),
      secondaryBackground: buildDismissBackground(alignment: Alignment.centerRight),
      onDismissed: (direction) {
        onDismissed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.white.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isCompleted
                ? Colors.grey.shade200
                : theme.colorScheme.primary.withOpacity(0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? Colors.black.withOpacity(0.02)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // Material widget is required here because the parent AnimatedContainer
        // paints its own background colour via BoxDecoration. Without a Material
        // ancestor between that decoration and the ListTile, Flutter cannot render
        // ink ripples or the tapped-state highlight — causing the
        // "ListTile background color or ink splashes may be invisible" assertion.
        // Using Colors.transparent preserves the rounded card background below.
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
            // Checkbox to mark complete / incomplete (Requirement 5)
            leading: Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: isCompleted,
                activeColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onChanged: (_) => onToggle(),
              ),
            ),
            // Task Title with Strikethrough effect (Requirement 6)
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isCompleted ? FontWeight.normal : FontWeight.w500,
                color: isCompleted ? Colors.grey.shade500 : Colors.grey.shade900,
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.grey.shade500,
                decorationThickness: 2.0,
              ),
            ),
            // Quick delete tap option
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.grey.shade400,
                size: 22,
              ),
              tooltip: 'Delete task',
              onPressed: onDeleteTap,
            ),
            onTap: onToggle,
          ),
        ),
      ),
    );
  }
}
