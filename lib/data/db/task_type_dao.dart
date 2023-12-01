// taskType_dao == type of task data access object

import 'package:sembast/sembast.dart';

import '../task_type.dart';
import 'app_database.dart';

class TaskTypeDao {
  final _taskTypeStore = intMapStoreFactory.store('tasksType');

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(TaskType taskType) async {
    await _taskTypeStore.add(
      await _db,
      taskType.toMap(),
    );
  }

  Future update(TaskType taskType) async {
    final finder = Finder(
      filter: Filter.byKey(taskType.idTaskType),
    );
    await _taskTypeStore.update(
      await _db,
      taskType.toMap(),
      finder: finder,
    );
  }

  Future delete(TaskType taskType) async {
    final finder = Finder(
      filter: Filter.byKey(taskType.idTaskType),
    );
    await _taskTypeStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<TaskType>> getAllInSortedOrder() async {
    final finder = Finder(
      sortOrders: [
        SortOrder('taskTypeName'),
      ],
    );

    final recordSnapshots =
        await _taskTypeStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final taskType = TaskType.fromMap(snapshot.value);
        taskType.idTaskType = snapshot.key;
        return taskType;
      },
    ).toList();
  }
}
