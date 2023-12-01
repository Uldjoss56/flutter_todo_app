import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../data/task_type.dart';
import '../../task_type_model/task_type_model.dart';

class TaskTypeForm extends StatefulWidget {
  final TaskType? editedTaskType;

  const TaskTypeForm({
    Key? key,
    this.editedTaskType,
  }) : super(key: key);

  @override
  State<TaskTypeForm> createState() => _TaskTypeFormState();
}

class _TaskTypeFormState extends State<TaskTypeForm> {
  final _formKey = GlobalKey<FormState>();

  late String _taskTypeName;

  bool get isEditMode => widget.editedTaskType != null;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8),
            children: [
              TextFormField(
                maxLines: null,
                onSaved: (newValue) => _taskTypeName = newValue!,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Task\'s Name',
                ),
                validator: _validateName,
                initialValue: widget.editedTaskType?.taskTypeName,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSavedTaskTypeButtonPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Save Task\'s type',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.task_alt,
                      size: 18,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a name';
    }
    return null;
  }

  void _onSavedTaskTypeButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final newOrEditedTaskType = TaskType(
        taskTypeName: _taskTypeName,
      );
      if (isEditMode) {
        newOrEditedTaskType.idTaskType = widget.editedTaskType!.idTaskType;
        ScopedModel.of<TasksTypeModel>(context).updateTaskType(
          newOrEditedTaskType,
        );
      } else {
        ScopedModel.of<TasksTypeModel>(context)
            .addTaskType(newOrEditedTaskType);
      }
      Navigator.of(context).pop();
    }
  }
}
