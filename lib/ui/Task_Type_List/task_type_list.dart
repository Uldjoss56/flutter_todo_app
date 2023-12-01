import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:third_flutter_project/data/task_type.dart';

import '../bottom_bar.dart';
import '../task_type/task_type_edit_page.dart';
import '../task_type_model/task_type_model.dart';
import '../task_type/task_type_create_page.dart';
import 'widget/task_type_tile.dart';

class TaskTypeListPage extends StatefulWidget {
  const TaskTypeListPage({Key? key}) : super(key: key);

  @override
  State<TaskTypeListPage> createState() => _TaskTypeListPageState();
}

class _TaskTypeListPageState extends State<TaskTypeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catégories',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ScopedModelDescendant<TasksTypeModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            model.loadTasksType();
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<TaskType> tasksTypes = model.tasksType!;
            List<TaskType> taskType2 = [];

            for (int i = 0; i != tasksTypes.length; i++) {
              if (tasksTypes[i].taskTypeName != "None") {
                taskType2.add(tasksTypes[i]);
              }
            }
            return Wrap(
              children: List.generate(
                taskType2.length,
                (index) {
                  final displayedTaskType = taskType2[index];
                  return GestureDetector(
                    onTap: () => _onTapedTypeTask(displayedTaskType),
                    child: Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                      margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      padding: const EdgeInsets.all(10),
                      height: 150,
                      width: 165,
                      child: TaskTypeTile(displayedTaskType: displayedTaskType),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF831B),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TaskTypeCreatePage(),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: BottomBar(),
      ),
    );
  }

  _onTapedTypeTask(TaskType displayedTaskType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskTypeEditPage(
          editedTaskType: displayedTaskType,
        ),
      ),
    );
  }
}
