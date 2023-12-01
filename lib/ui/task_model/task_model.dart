import 'package:scoped_model/scoped_model.dart';
import 'package:third_flutter_project/data/db/task_dao.dart';
import 'package:third_flutter_project/data/sort_state.dart';

import '../../data/task.dart';

class TasksModel extends Model {
  final TaskDao _taskDao = TaskDao();

  List<SortState>? _sortState;
  List<SortState>? get state => _sortState;

  List<Task>? _tasks;
  List<Task>? get tasks => _tasks;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future loadState() async {
    _isLoading = true;
    notifyListeners();
    _sortState = await _taskDao.getAllSortState();
    loadTasks(_sortState![0].stateName);
  }

  Future loadTasks(String orderChoice) async {
    _isLoading = true;
    notifyListeners();
    switch (orderChoice) {
      case "default":
        _tasks = await _taskDao.getAllInSortedOrder();
        break;
      case "taskName":
        _tasks = await _taskDao.getAllInAlphaOrder();
        break;
      case "taskSDate":
        _tasks = await _taskDao.getAllInStDateOrder();
        break;
      case "taskStatus":
        _tasks = await _taskDao.getAllInStatusOrder();
        break;
      case "taskDuration":
        _tasks = await _taskDao.getAllInDurationOrder();
        break;
      case "type":
        _tasks = await _taskDao.getAllInTypeOrder();
        break;
      default:
    }
    _isLoading = false;
    notifyListeners();
  }

  Future loadTasksForSearch(String value) async {
    _isLoading = true;
    notifyListeners();
    _sortState = await _taskDao.getAllSortState();
    notifyListeners();
    _tasks = await _taskDao.forLoadFoundTask(value);
    _isLoading = false;
    notifyListeners();
  }

  Future addTask(Task task) async {
    await _taskDao.insert(task);
    await loadState();
    notifyListeners();
  }

  Future updateTask(Task task) async {
    await _taskDao.update(task);
    await loadState();
    notifyListeners();
  }

  Future deleteTask(Task task) async {
    await _taskDao.delete(task);
    await loadState();
    notifyListeners();
  }

  Future updateState(SortState state) async {
    await _taskDao.updateTaskOrderState(state);
    await loadState();
    notifyListeners();
  }

  Future deleteTypeInTask(int? idTaskType, int idNone) async {
    if (!_isLoading) {
      for (Task task in _tasks!) {
        if (task.idTaskType == idTaskType) {
          task.idTaskType = idNone;
          updateTask(task);
        }
      }
    }
  }
}
