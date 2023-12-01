import 'package:flutter/material.dart';

import '../../../data/task_type.dart';

class TaskTypeTile extends StatelessWidget {
  const TaskTypeTile({
    super.key,
    required this.displayedTaskType,
  });

  final TaskType displayedTaskType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        displayedTaskType.taskTypeName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
