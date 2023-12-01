import 'package:scoped_model/scoped_model.dart';

import '../../data/db/task_type_dao.dart';
import '../../data/task_type.dart';

class TasksTypeModel extends Model {
  final TaskTypeDao _taskTypeDao = TaskTypeDao();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future loadTasksType() async {
    _isLoading = true;
    notifyListeners();
    _tasksType = await _taskTypeDao.getAllInSortedOrder();
    _isLoading = false;
    notifyListeners();
  }

  List<TaskType>? _tasksType;

  List<TaskType>? get tasksType => _tasksType;

  Future addTaskType(TaskType taskType) async {
    await _taskTypeDao.insert(taskType);
    await loadTasksType();
    notifyListeners();
  }

  Future updateTaskType(TaskType taskType) async {
    await _taskTypeDao.insert(taskType);
    await loadTasksType();
    notifyListeners();
  }

  Future deleteTaskType(TaskType taskType) async {
    await _taskTypeDao.delete(taskType);
    await loadTasksType();
    notifyListeners();
  }
}
