import 'package:flutter/material.dart';

/// TaskSummaryCard Widget
///
/// Dynamically displays:
/// - Total remaining tasks count (Requirement 8)
/// - Visual completion progress bar
/// - Positive dynamic status messages
class TaskSummaryCard extends StatelessWidget {
  final int totalTasks;
  final int remainingTasks;

  const TaskSummaryCard({
    super.key,
    required this.totalTasks,
    required this.remainingTasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedTasks = totalTasks - remainingTasks;
    final progress = totalTasks == 0 ? 0.0 : (completedTasks / totalTasks);

    // Determine friendly dynamic status text
    String statusSubtitle;
    if (totalTasks == 0) {
      statusSubtitle = 'Your task list is empty. Add a task to begin!';
    } else if (remainingTasks == 0) {
      statusSubtitle = 'All done! Awesome work today! 🎉';
    } else {
      statusSubtitle = '$completedTasks of $totalTasks tasks completed';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            const Color(0xFF4338CA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Remaining Tasks',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Dynamic remaining count (Requirement 8)
                  Text(
                    '$remainingTasks',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Circular / pill badge showing percentage
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(progress * 100).toInt()}% Done',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Visual progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          // Dynamic status subtitle
          Text(
            statusSubtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
