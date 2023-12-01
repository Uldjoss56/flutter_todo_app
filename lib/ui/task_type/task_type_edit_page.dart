import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:third_flutter_project/ui/task_model/task_model.dart';

import '../../data/task_type.dart';
import '../task_type_model/task_type_model.dart';
import 'widget/task_type_form.dart';

class TaskTypeEditPage extends StatelessWidget {
  const TaskTypeEditPage({
    Key? key,
    required this.editedTaskType,
  }) : super(key: key);

  final TaskType editedTaskType;

  TaskType get editedTask => editedTaskType;

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem<String>> options = [
      const PopupMenuItem(
        value: 'delete',
        child: Text('Delete'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(itemBuilder: (BuildContext context) {
            return options;
          }, onSelected: (String value) {
            switch (value) {
              case 'delete':
                int idNone = 0,
                    idTaskType = editedTaskType.idTaskType!,
                    taille = ScopedModel.of<TasksTypeModel>(context)
                        .tasksType!
                        .length;

                List<TaskType> tasksTypes =
                    ScopedModel.of<TasksTypeModel>(context).tasksType!;

                for (int i = 0; i != taille; i++) {
                  if (tasksTypes[i].taskTypeName == "None") {
                    idNone = tasksTypes[i].idTaskType!;
                  }
                }
                ScopedModel.of<TasksModel>(context)
                    .deleteTypeInTask(idTaskType, idNone);

                ScopedModel.of<TasksTypeModel>(context)
                    .deleteTaskType(editedTaskType);
                Navigator.of(context).pop();
                break;
              default:
            }
          }),
        ],
      ),
      body: TaskTypeForm(
        editedTaskType: editedTaskType,
      ),
    );
  }
}
