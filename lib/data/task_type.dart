class TaskType {
  int? idTaskType;
  String taskTypeName;

  TaskType({
    this.idTaskType,
    required this.taskTypeName,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskTypeName': taskTypeName,
    };
  }

  static TaskType fromMap(Map<String, dynamic> map) {
    return TaskType(
      taskTypeName: map['taskTypeName'],
    );
  }
}
