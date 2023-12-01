import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import "package:intl/intl.dart";
import 'package:third_flutter_project/data/task_type.dart';

import '../../../data/task.dart';
import '../../task_model/task_model.dart';
import '../../task_type_model/task_type_model.dart';

class TaskForm extends StatefulWidget {
  final Task? editedTask;

  const TaskForm({
    Key? key,
    this.editedTask,
  }) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  late String _taskName;
  late String _taskDescription;
  Duration _taskDuration = Duration.zero;
  DateTime _startTaskDay = DateTime.now();
  DateTime _endTaskDay = DateTime.now();
  int _idTaskType = 0;
  late bool _taskIsEnded;

  String _durationUnit = 'HH:mm:ss';

  bool get isEditMode => widget.editedTask != null;

  final _startDayController = TextEditingController();
  final _endDayController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _durationController.text = isEditMode
        ? '${widget.editedTask?.taskDuration.inHours}:${(widget.editedTask!.taskDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(widget.editedTask!.taskDuration.inSeconds.toInt() % 60).toString().padLeft(2, '0')}'
            .toString()
        : '${_taskDuration.inHours.toString().padLeft(2, '0')}:${(_taskDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(_taskDuration.inSeconds.toInt() % 60).toString().padLeft(2, '0')}'
            .toString();

    _durationController.addListener(_formatDuration);
    _startDayController.text = DateFormat.yMd().add_jm().format(
          isEditMode ? widget.editedTask!.startTaskDay : _startTaskDay,
        );
    _endDayController.text = DateFormat.yMd().add_jm().format(
          isEditMode ? widget.editedTask!.endTaskDay! : _endTaskDay,
        );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _startDayController.dispose();
    _endDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      _taskIsEnded = widget.editedTask!.taskIsEnded!;
      _startTaskDay = widget.editedTask!.startTaskDay;
      _endTaskDay = widget.editedTask!.endTaskDay!;
    } else {
      _taskIsEnded = false;
    }
    return ScopedModelDescendant<TasksTypeModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          model.loadTasksType();
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<TaskType>? displayedTaskTypes = model.tasksType;

          for (int i = 0; i != displayedTaskTypes!.length; i++) {
            if (displayedTaskTypes[i].taskTypeName == "None") {
              _idTaskType = displayedTaskTypes[i].idTaskType!;
            }
          }
          return Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Taskly",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFFFF741F),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: null,
                  onSaved: (newValue) => _taskName = newValue!,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: "Task's Name",
                  ),
                  validator: _validateName,
                  initialValue: widget.editedTask?.taskName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: null,
                  onSaved: (newValue) => _taskDescription = newValue!,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: _validateDescription,
                  initialValue: widget.editedTask?.taskDescription,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateDuration,
                        maxLength: _durationUnit == 'HH:mm:ss' ? 8 : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _durationUnit,
                        items: [
                          'HH:mm:ss',
                          'secondes',
                          'minutes',
                          'hours',
                          'days',
                          'weeks',
                          'months',
                          'years',
                        ]
                            .map((label) => DropdownMenuItem(
                                  value: label,
                                  child: SizedBox(
                                    width: 100,
                                    child: Text(
                                      label,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _durationUnit = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Unité de durée',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: _idTaskType,
                  items: displayedTaskTypes.map(
                    (label) {
                      return DropdownMenuItem(
                        value: label.idTaskType,
                        child: Text(label.taskTypeName),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(
                      () {},
                    );
                  },
                  onSaved: (newValue) {
                    _idTaskType = newValue!;
                  },
                  decoration: const InputDecoration(
                    labelText: "Task's Type",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _startDayController,
                  decoration: const InputDecoration(
                    labelText: 'Start day',
                  ),
                  validator: _validateStartDate,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _startTaskDay,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (date != null) {
                      // ignore: use_build_context_synchronously
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );
                      if (time != null) {
                        setState(
                          () {
                            _startTaskDay = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                            _startDayController.text =
                                DateFormat.yMd().add_jm().format(_startTaskDay);
                          },
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _endDayController,
                  decoration: const InputDecoration(
                    labelText: 'End day',
                  ),
                  validator: _validateEndDate,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _endTaskDay,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (date != null) {
                      // ignore: use_build_context_synchronously
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );
                      if (time != null) {
                        setState(
                          () {
                            _endTaskDay = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                            _endDayController.text =
                                DateFormat.yMd().add_jm().format(_endTaskDay);
                          },
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onSavedTaskButtonPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      150,
                      50,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Save Task',
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
          );
        }
      },
    );
  }

  bool isValidTimeFormat(String input) {
    RegExp regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$');
    return regex.hasMatch(input);
  }

  void _formatDuration() {
    final text = _durationController.text;
    String formattedText = "";
    if (_durationUnit == 'HH:mm:ss') {
      if (text.length == 2 && text[1] != ':') {
        formattedText = '$text:';
      }
      if (formattedText != '' && formattedText != text) {
        _durationController.value = _durationController.value.copyWith(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
  }

  String? _validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a duration.';
    }

    if (_durationUnit == 'HH:mm:ss') {
      if (!isValidTimeFormat(value)) {
        return 'Invalid. Format: HH:mm:ss';
      } else {
        int varSize = value.length;
        int seconds = int.parse(value[varSize - 2] + value[varSize - 1]);
        int minutes = int.parse(value[varSize - 5] + value[varSize - 4]);
        int hours = int.parse(value.substring(0, varSize - 6));
        seconds = seconds + minutes * 60 + hours * 3600;
        if (seconds == 0) {
          return "Can't be equal to 0";
        }
        _taskDuration = Duration(seconds: seconds);
        return null;
      }
    } else {
      if (int.tryParse(value) == null) {
        return 'Invalid duration. Expected a whole number.';
      } else {
        try {
          int seconds = int.parse(value);
          if (seconds == 0) {
            return "Duration can't be equal to 0";
          }
          switch (_durationUnit) {
            case 'secondes':
              _taskDuration = Duration(seconds: seconds);
              break;
            case 'minutes':
              _taskDuration = Duration(minutes: seconds);
              break;
            case 'hours':
              _taskDuration = Duration(hours: seconds);
              break;
            case 'days':
              _taskDuration = Duration(days: seconds);
              break;
            case 'weeks':
              _taskDuration = Duration(days: seconds * 7);
              break;
            case 'months':
              _taskDuration = Duration(days: seconds * 30);
              break;
            case 'years':
              _taskDuration = Duration(days: seconds * 365);
              break;
            default:
              return 'Invalid duration unit.';
          }
        } catch (e) {
          return 'Invalid duration.';
        }
      }
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a name';
    }
    if (value.toLowerCase() == 'none') {
      return "'None' est invalide";
    }
    if (value.length > 20) {
      return "No more than 20 characters";
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value!.length > 240) {
      return "No more than 240 characters";
    }
    return null;
  }

  String? _validateEndDate(String? value) {
    if (_endTaskDay.isBefore(_startTaskDay) ||
        _endTaskDay.isBefore(
            _startTaskDay.add(Duration(seconds: _taskDuration.inSeconds)))) {
      return "Invalid ended's date";
    }
    return null;
  }

  String? _validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter the start's date";
    }
    return null;
  }

  void _onSavedTaskButtonPressed() {
    if (_endTaskDay.year == _startTaskDay.year &&
        _endTaskDay.month == _startTaskDay.month &&
        _endTaskDay.day == _startTaskDay.day &&
        _endTaskDay.hour == _startTaskDay.hour &&
        _endTaskDay.minute == _startTaskDay.minute) {
      _endTaskDay = _endTaskDay.add(Duration(seconds: _taskDuration.inSeconds));
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final newOrEditedTask = Task(
        taskName: _taskName,
        taskDescription: _taskDescription,
        taskDuration: _taskDuration,
        startTaskDay: _startTaskDay,
        endTaskDay: _endTaskDay,
        taskIsEnded: _taskIsEnded,
        idTaskType: _idTaskType,
      );
      if (isEditMode) {
        newOrEditedTask.idTask = widget.editedTask!.idTask;
        ScopedModel.of<TasksModel>(context).updateTask(newOrEditedTask);
      } else {
        ScopedModel.of<TasksModel>(context).addTask(newOrEditedTask);
      }
      Navigator.of(context).pop();
      if (isEditMode) {
        Navigator.of(context).pop();
      }
    }
  }
}
