import 'package:flutter/material.dart';

class TaskCompleteDialog extends StatelessWidget {
  const TaskCompleteDialog({
    super.key,
    // required this.onPressedShare,
    required this.onPressedDismiss,
  });

  // final Function onPressedShare;
  final Function onPressedDismiss;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: MaterialBanner(
        content: const Text(
          'You\'ve completed a task!',
        ),
        leading: const CircleAvatar(
          child: Icon(
            Icons.checklist,
          ),
        ),
        actions: [
          // TextButton(
          //   child: const Text('Share to your circles!'),
          //   onPressed: () => onPressedShare(),
          // ),
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () => onPressedDismiss(),
          ),
        ],
      ),
    );
  }
}
