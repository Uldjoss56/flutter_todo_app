// task_dao == task data access object

import 'dart:async';

import 'package:sembast/sembast.dart';

import '../sort_state.dart';
import '../task.dart';
import 'app_database.dart';

class TaskDao {
  final _taskStore = intMapStoreFactory.store('tasks');

  final _taskAndTypeSortStateStore =
      intMapStoreFactory.store('tasksAndTypesSortState');

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Task task) async {
    await _taskStore.add(
      await _db,
      task.toMap(),
    );
  }

  Future update(Task task) async {
    final finder = Finder(
      filter: Filter.byKey(task.idTask),
    );
    await _taskStore.update(
      await _db,
      task.toMap(),
      finder: finder,
    );
  }

  Future delete(Task task) async {
    final finder = Finder(
      filter: Filter.byKey(task.idTask),
    );
    await _taskStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Task>> getAllInSortedOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('startTaskDay', false),
      SortOrder('taskDuration', false),
      SortOrder('taskName'),
    ]);

    final recordSnapshots = await _taskStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final task = Task.fromMap(snapshot.value);
        task.idTask = snapshot.key;
        return task;
      },
    ).toList();
  }

  Future<List<Task>> getAllInAlphaOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('taskName'),
    ]);

    final recordSnapshots = await _taskStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final task = Task.fromMap(snapshot.value);
        task.idTask = snapshot.key;
        return task;
      },
    ).toList();
  }

  Future<List<Task>> getAllInStDateOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('startTaskDay', false),
    ]);

    final recordSnapshots = await _taskStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final task = Task.fromMap(snapshot.value);
        task.idTask = snapshot.key;
        return task;
      },
    ).toList();
  }

  Future<List<Task>> getAllInStatusOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('endTaskDay', false),
    ]);

    final recordSnapshots = await _taskStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final task = Task.fromMap(snapshot.value);
        task.idTask = snapshot.key;
        return task;
      },
    ).toList();
  }

  Future<List<Task>> getAllInDurationOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('taskDuration', false),
    ]);

    final recordSnapshots = await _taskStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final task = Task.fromMap(snapshot.value);
        task.idTask = snapshot.key;
        return task;
      },
    ).toList();
  }

  Future<List<Task>> getAllInTypeOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('idTaskType', false),
    ]);

    final recordSnapshots = await _taskStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final task = Task.fromMap(snapshot.value);
        task.idTask = snapshot.key;
        return task;
      },
    ).toList();
  }

  Future updateTaskOrderState(SortState orderChoice) async {
    final finder = Finder(
      filter: Filter.byKey(orderChoice.stateId),
    );
    await _taskAndTypeSortStateStore.update(
      await _db,
      orderChoice.toMap(),
      finder: finder,
    );
  }

  Future<List<SortState>> getAllSortState() async {
    final finder = Finder(sortOrders: [
      SortOrder('stateName'),
    ]);

    final recordSnapshots =
        await _taskAndTypeSortStateStore.find(await _db, finder: finder);

    return recordSnapshots.map(
      (snapshot) {
        final state = SortState.fromMap(snapshot.value);
        state.stateId = snapshot.key;
        return state;
      },
    ).toList();
  }

  Future<List<Task>> forLoadFoundTask(String value) async {
    final finder = Finder(
      filter: Filter.custom(
        (record) {
          final task = Task.fromMap(record.value as Map<String, dynamic>);
          return task.taskName.contains(value);
        },
      ),
    );
    final taskSnapshots = await _taskStore.find(await _db, finder: finder);

    return taskSnapshots.map(
      (snapshot) {
        final task = Task.fromMap(snapshot.value);
        task.idTask = snapshot.key;
        return task;
      },
    ).toList();
  }
}
