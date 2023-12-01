import 'package:flutter/material.dart';
import 'package:third_flutter_project/ui/task/widget/task_form.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Create",
        style: TextStyle(
          color: Colors.white,
        ),
      )),
      body: const TaskForm(),
    );
  }
}
