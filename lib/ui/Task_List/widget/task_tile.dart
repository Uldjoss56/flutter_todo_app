import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:third_flutter_project/data/task.dart';
import 'package:third_flutter_project/ui/task/view_task_detail.dart';
import 'package:third_flutter_project/ui/task_model/task_model.dart';

import 'create_rising_flow.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    Key? key,
    required this.taskIndex,
  }) : super(key: key);

  final int taskIndex;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<TasksModel>(context);
    Task displayedTask = model.tasks![taskIndex];

    return Slidable(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.fromLTRB(0, 2, 2, 2),
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
        child: ListTile(
          textColor: const Color(0xFF111111),
          title: Text(
            displayedTask.taskName,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: AutofillHints.name,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Duration : ${displayedTask.taskDuration.inDays} dys '
            '${(displayedTask.taskDuration.inHours % 24).toString().padLeft(2, '0')} h '
            '${(displayedTask.taskDuration.inMinutes % 60).toString().padLeft(2, '0')} mn'
            '\nStart : ${displayedTask.startTaskDay.year}-${displayedTask.startTaskDay.month.toString().padLeft(2, '0')}'
            '-${displayedTask.startTaskDay.day.toString().padLeft(2, '0')}  ${displayedTask.startTaskDay.hour.toString().padLeft(2, '0')}:'
            '${displayedTask.startTaskDay.minute.toString().padLeft(2, '0')}:${displayedTask.startTaskDay.second.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          leading: buildCircleAvatar(displayedTask),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ViewTaskDetail(
                  editedTask: displayedTask,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Hero buildCircleAvatar(Task displayedTask) {
    return Hero(
      tag: displayedTask.hashCode,
      child: TaskDurationIcon(
        task: displayedTask,
      ),
    );
  }
}
