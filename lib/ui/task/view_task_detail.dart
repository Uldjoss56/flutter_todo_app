import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:third_flutter_project/ui/task_type_model/task_type_model.dart';

import '../../data/task.dart';
import '../Task_List/widget/count_down_screen.dart';
import '../task_model/task_model.dart';
import 'task_edit_page.dart';

class ViewTaskDetail extends StatefulWidget {
  final Task editedTask;

  const ViewTaskDetail({
    Key? key,
    required this.editedTask,
  }) : super(key: key);

  @override
  State<ViewTaskDetail> createState() => _ViewTaskDetailState();
}

class _ViewTaskDetailState extends State<ViewTaskDetail> {
  late String taskTypeName2;

  get editedTask => widget.editedTask;

  List<PopupMenuEntry<String>> options = [
    const PopupMenuItem(
      value: 'endTask',
      child: Text('End this task'),
    ),
    const PopupMenuDivider(height: 20),
    const PopupMenuItem(
      value: 'edit',
      child: Text('Edit'),
    ),
    const PopupMenuDivider(height: 20),
    const PopupMenuItem(
      value: 'delete',
      child: Text('Delete'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final editedTaskOnStatus = widget.editedTask;
    final model = ScopedModel.of<TasksModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "One Task View",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TaskEditPage(
                    editedTask: editedTask,
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.edit,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return options;
            },
            color: Colors.white,
            onSelected: (String value) => _onClickedMenu(value),
          ),
        ],
      ),
      body: ScopedModelDescendant<TasksTypeModel>(
          builder: (context, child, modele) {
        if (modele.isLoading) {
          modele.loadTasksType();
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          for (int i = 0; i != modele.tasksType!.length; i++) {
            if (modele.tasksType![i].idTaskType ==
                editedTaskOnStatus.idTaskType) {
              taskTypeName2 = modele.tasksType![i].taskTypeName;
            }
          }
          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x99FF741F).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 200,
                      child: Text(
                        widget.editedTask.taskName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: Color(0x99FF741F),
                        ),
                      ),
                    ),
                    if (editedTaskOnStatus.taskIsEnded!)
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Row(
                          children: [
                            Text(
                              "Task Ended",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              editedTaskOnStatus.taskDescription!.isNotEmpty
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(5, 16, 5, 0),
                            child: const Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0x99FF741F),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            editedTaskOnStatus.taskDescription!,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(height: 0),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 16, 5, 0),
                child: const Text(
                  "Catégorie",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0x99FF741F),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                padding: const EdgeInsets.all(10),
                child: Text(
                  taskTypeName2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                margin: const EdgeInsets.fromLTRB(4, 0, 250, 0),
                child: const Divider(
                  thickness: 2,
                  height: 1,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xBBFFFFFF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                padding: const EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      if (editedTaskOnStatus.startTaskDay
                          .isBefore(DateTime.now()))
                        WidgetSpan(
                          child: CountDownScreen(
                            task: editedTaskOnStatus,
                          ),
                        )
                      else
                        const WidgetSpan(
                          child: Center(
                            heightFactor: 2,
                            child: Text(
                              "Not Start yet",
                              style: TextStyle(
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text(
                          "Start",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0x99FF741F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            DateFormat.yMd().add_jm().format(
                                  editedTaskOnStatus.startTaskDay,
                                ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Text(
                          "End",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0x99FF741F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            DateFormat.yMd().add_jm().format(
                                  editedTaskOnStatus.endTaskDay!,
                                ),
                            style: const TextStyle(
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!editedTaskOnStatus.taskIsEnded!)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x99FF741F).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.red[400],
                  ),
                  margin: const EdgeInsets.fromLTRB(50, 10, 50, 50),
                  child: TextButton(
                    onPressed: () {
                      editedTaskOnStatus.taskIsEnded = true;
                      setState(
                        () {
                          model.updateTask(
                            editedTaskOnStatus,
                          );
                        },
                      );
                    },
                    child: const Text(
                      "End Task",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
            ],
          );
        }
      }),
    );
  }

  _onClickedMenu(String value) {
    var model = ScopedModel.of<TasksModel>(context);
    switch (value) {
      case 'delete':
        model.deleteTask(editedTask);
        Navigator.of(context).pop();
        break;
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TaskEditPage(
              editedTask: editedTask,
            ),
          ),
        );
        break;
      case 'endTask':
        var isEdit = widget.editedTask;
        isEdit.taskIsEnded = true;
        setState(
          () {
            model.updateTask(
              isEdit,
            );
          },
        );
        break;
      default:
    }
  }
}
