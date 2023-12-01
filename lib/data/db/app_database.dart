import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:third_flutter_project/data/sort_state.dart';

import '../task_type.dart';

class AppDatabase {
  static final AppDatabase _singleton = AppDatabase._();

  static AppDatabase get instance => _singleton;

  Completer<Database>? _dbOpenCompleter;

  AppDatabase._();

  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'tasks.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);

    final storeTypes = intMapStoreFactory.store('tasksType');
    final taskTypes = await storeTypes.find(database);

    final storeState = intMapStoreFactory.store('tasksAndTypesSortState');
    final states = await storeState.find(database);

    if (taskTypes.isEmpty) {
      final taskType = TaskType(taskTypeName: 'None');
      await storeTypes.add(database, taskType.toMap());
    }

    if (states.isEmpty) {
      final sortTaskState = SortState(stateName: 'default');
      await storeState.add(database, sortTaskState.toMap());
    }

    _dbOpenCompleter?.complete(database);
  }
}
