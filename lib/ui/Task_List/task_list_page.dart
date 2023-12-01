import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:third_flutter_project/ui/Task_List/widget/task_tile.dart';
import 'package:third_flutter_project/ui/task_model/task_model.dart';

import '../../data/sort_state.dart';
import '../bottom_bar.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPage();
}

class _TaskListPage extends State<TaskListPage> {
  List<PopupMenuEntry<String>> options = [
    const PopupMenuItem(
      value: 'selectAll',
      child: Row(
        children: [
          Icon(
            Icons.select_all,
            color: Color(0xFFFF741F),
          ),
          SizedBox(width: 8),
          Text('Select all'),
        ],
      ),
    ),
    const PopupMenuDivider(height: 20),
    const PopupMenuItem(
      value: 'sort',
      child: Row(
        children: [
          Icon(
            Icons.sort,
            color: Color(0xFFFF741F),
          ),
          SizedBox(width: 8),
          Text('Sort by'),
        ],
      ),
    ),
  ];
  bool isSearching = false;
  bool? isNotAlready = true;
  String nameSearching = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text(
                'Taskly',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  onChanged: (value) => loadFoundTask(value),
                  decoration: const InputDecoration(
                    hintText: 'Rechercher...',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(
                () {
                  isSearching = !isSearching;
                },
              );
            },
          ),
          const SizedBox(width: 30),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return options;
            },
            shadowColor: Colors.black,
            onSelected: (String value) => _onClickedMenu(value),
          ),
        ],
      ),
      body: ScopedModelDescendant<TasksModel>(
        builder: (context, child, model) {
          if (model.isLoading && !isSearching) {
            model.loadState();
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (isSearching && isNotAlready!) {
            model.loadTasksForSearch(nameSearching);
            isNotAlready = false;
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                itemCount: model.tasks!.length,
                itemBuilder: (context, index) {
                  return TaskTile(taskIndex: index);
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const SizedBox(
        height: 60,
        child: BottomBar(),
      ),
    );
  }

  void _onClickedMenu(String value) {
    switch (value) {
      case 'sort':
        List<PopupMenuEntry<String>> optionSort = [
          const PopupMenuItem(
            value: 'name',
            child: Row(
              children: [
                Icon(
                  Icons.sort_by_alpha,
                  color: Color(0xFFFF741F),
                ),
                SizedBox(width: 8),
                Text('Sort by Name'),
              ],
            ),
          ),
          const PopupMenuDivider(height: 20),
          const PopupMenuItem(
            value: 'sDay',
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Color(0xFFFF741F),
                ),
                SizedBox(width: 8),
                Text('Sort by Start Day'),
              ],
            ),
          ),
          const PopupMenuDivider(height: 20),
          const PopupMenuItem(
            value: 'type',
            child: Row(
              children: [
                Icon(
                  Icons.category,
                  color: Color(0xFFFF741F),
                ),
                SizedBox(width: 8),
                Text('Sort by Categories'),
              ],
            ),
          ),
          const PopupMenuDivider(height: 20),
          const PopupMenuItem(
            value: 'taskStatus',
            child: Row(
              children: [
                Icon(
                  Icons.check_box,
                  color: Color(0xFFFF741F),
                ),
                SizedBox(width: 8),
                Text('Sort by Task Status'),
              ],
            ),
          ),
          const PopupMenuDivider(height: 20),
          const PopupMenuItem(
            value: 'taskDuration',
            child: Row(
              children: [
                Icon(
                  Icons.timelapse,
                  color: Color(0xFFFF741F),
                ),
                SizedBox(width: 8),
                Text('Sort by Task Durations'),
              ],
            ),
          ),
          const PopupMenuDivider(height: 20),
          const PopupMenuItem(
            value: 'default',
            child: Row(
              children: [
                Icon(
                  Icons.deck,
                  color: Color(0xFFFF741F),
                ),
                SizedBox(width: 8),
                Text('Default Sort'),
              ],
            ),
          ),
        ];

        showMenu(
            context: context,
            position: RelativeRect.fromDirectional(
              textDirection: TextDirection.ltr,
              start: 10,
              top: 250,
              end: 10,
              bottom: 0,
            ),
            items: optionSort,
            elevation: 8,
            shadowColor: const Color(0xFFFF741F),
            shape: Border.all(
              color: const Color(0x99FF741F),
              style: BorderStyle.solid,
              strokeAlign: 5,
            )).then(
          (selectedValue) {
            if (selectedValue != null) {
              _onClickedSubMenu(selectedValue);
            }
          },
        );
        break;
      default:
    }
  }

  void _onClickedSubMenu(String value) {
    switch (value) {
      case 'name':
        SortState newState = SortState(
          stateName: 'taskName',
        );
        newState.stateId =
            ScopedModel.of<TasksModel>(context).state![0].stateId;
        setState(() {
          ScopedModel.of<TasksModel>(context).updateState(newState);
        });
        break;
      case 'sDay':
        SortState newState = SortState(
          stateName: 'taskSDate',
        );
        newState.stateId =
            ScopedModel.of<TasksModel>(context).state![0].stateId;
        setState(() {
          ScopedModel.of<TasksModel>(context).updateState(newState);
        });
        break;
      case 'taskStatus':
        SortState newState = SortState(
          stateName: 'taskStatus',
        );
        newState.stateId =
            ScopedModel.of<TasksModel>(context).state![0].stateId;
        setState(() {
          ScopedModel.of<TasksModel>(context).updateState(newState);
        });
        break;
      case 'taskDuration':
        SortState newState = SortState(
          stateName: 'taskDuration',
        );
        newState.stateId =
            ScopedModel.of<TasksModel>(context).state![0].stateId;
        setState(() {
          ScopedModel.of<TasksModel>(context).updateState(newState);
        });
        break;
      case 'type':
        SortState newState = SortState(
          stateName: 'type',
        );
        newState.stateId =
            ScopedModel.of<TasksModel>(context).state![0].stateId;
        setState(() {
          ScopedModel.of<TasksModel>(context).updateState(newState);
        });
        break;
      case 'default':
        SortState newState = SortState(
          stateName: 'default',
        );
        newState.stateId =
            ScopedModel.of<TasksModel>(context).state![0].stateId;
        setState(() {
          ScopedModel.of<TasksModel>(context).updateState(newState);
        });
        break;
      default:
    }
  }

  loadFoundTask(String value) {
    setState(
      () {
        nameSearching = value;
      },
    );
  }
}
