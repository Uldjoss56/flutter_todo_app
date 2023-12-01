import 'package:flutter/material.dart';
import 'package:third_flutter_project/data/task.dart';
import 'package:third_flutter_project/ui/task/widget/task_form.dart';

class TaskEditPage extends StatelessWidget {
  final Task editedTask;

  const TaskEditPage({
    Key? key,
    required this.editedTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: TaskForm(
        editedTask: editedTask,
      ),
    );
  }
}
