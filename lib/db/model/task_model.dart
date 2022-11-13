const String tableTask = 'tasks';

class TaskFields {
  static const String id = "_id";

  static const String title = "title";

  static const String description = "description";
  static const String duration = "duration";
  static const String status = "status";

  static final List<String> values = [id, title, description, duration, status];
}

class TaskModel {
  final int? id;
  final String title;
  final String? description;
  final String duration;
  final String status;

  const TaskModel(
      {this.id,
      this.description,
      required this.duration,
      required this.title,
      required this.status});

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.description: description,
        TaskFields.duration: duration,
        TaskFields.status: status
      };

  static TaskModel fromJson(Map<String, Object?> json) => TaskModel(
        id: json[TaskFields.id] as int?,
        title: json[TaskFields.title] as String,
        description: json[TaskFields.description] as String,
        duration: json[TaskFields.duration] as String,
        status: json[TaskFields.status] as String,
      );

  TaskModel copy({int? id}) => TaskModel(
        id: id ?? this.id,
        duration: duration,
        title: title,
        description: description,
        status: status,
      );
}
