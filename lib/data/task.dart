class Task {
  int? idTask;
  int? idTaskType;
  String taskName;
  String? taskDescription;
  DateTime startTaskDay;
  DateTime? endTaskDay;
  Duration taskDuration;
  bool? taskIsEnded = false;

  Task({
    this.idTask,
    this.idTaskType,
    required this.taskName,
    this.taskDescription,
    required this.startTaskDay,
    this.endTaskDay,
    required this.taskDuration,
    this.taskIsEnded,
  });
/*
  Task copyWith({
    Duration? taskDuration,
    String? taskName,
    String? taskDescription,
    DateTime? endTaskDay,
    DateTime? startTaskDay,
    bool? taskIsEnded,
    int? idTaskType,
  }) {
    return Task(
      taskName: taskName!,
      startTaskDay: startTaskDay!,
      taskDuration: taskDuration!,
      taskDescription: taskDescription,
      endTaskDay: endTaskDay,
      taskIsEnded: taskIsEnded,
      idTaskType: idTaskType,
    );
  }
*/
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'idTaskType': idTaskType,
      'taskDescription': taskDescription,
      'taskIsEnded': taskIsEnded! ? 1 : 0,
      'taskDuration': taskDuration.inMilliseconds,
      'startTaskDay': startTaskDay.millisecondsSinceEpoch,
      'endTaskDay': endTaskDay?.millisecondsSinceEpoch,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      taskName: map['taskName'],
      startTaskDay: DateTime.fromMillisecondsSinceEpoch(map['startTaskDay']),
      taskDuration: Duration(milliseconds: map['taskDuration']),
      idTaskType: map['idTaskType'],
      taskDescription: map['taskDescription'],
      taskIsEnded: map['taskIsEnded'] == 1,
      endTaskDay: map['endTaskDay'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTaskDay'])
          : null,
    );
  }
}
