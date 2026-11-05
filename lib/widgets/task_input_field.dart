import 'package:flutter/material.dart';

/// TaskInputField Widget
///
/// Contains:
/// - Text field for typing tasks (Requirement 2)
/// - Add button to submit tasks (Requirement 3)
/// - Empty task input validation (Requirement 12)
class TaskInputField extends StatefulWidget {
  final ValueChanged<String> onAddTask;

  const TaskInputField({
    super.key,
    required this.onAddTask,
  });

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitTask() {
    final enteredText = _controller.text.trim();

    // Validation: Check for empty or whitespace-only input (Requirement 12)
    if (enteredText.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Please enter a task before adding!'),
            ],
          ),
          backgroundColor: Colors.amber.shade800,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Call the parent callback to add the task
    widget.onAddTask(enteredText);

    // Clear input field and maintain focus for easy subsequent entries
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text Field for entering task (Requirement 2)
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Add a new task...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.add_task_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _submitTask(),
            ),
          ),
          const SizedBox(width: 8),
          // Add Button (Requirement 3)
          FilledButton.icon(
            onPressed: _submitTask,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'Add',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
