import 'package:flutter/material.dart';

import 'widget/task_type_form.dart';

class TaskTypeCreatePage extends StatelessWidget {
  const TaskTypeCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: const TaskTypeForm(),
    );
  }
}
