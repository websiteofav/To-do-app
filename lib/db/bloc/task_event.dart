part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {}

class GetTaskEvent extends TaskEvent {
  final int id;

  GetTaskEvent({required this.id});
  @override
  List<Object> get props => throw UnimplementedError();
}

class GetAllTaskEvent extends TaskEvent {
  GetAllTaskEvent();
  @override
  List<Object> get props => throw UnimplementedError();
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel model;

  UpdateTaskEvent({required this.model});
  @override
  List<Object> get props => throw UnimplementedError();
}

class DeleteTaskEvent extends TaskEvent {
  final int id;

  DeleteTaskEvent({required this.id});
  @override
  List<Object> get props => throw UnimplementedError();
}

class AddTaskEvent extends TaskEvent {
  final String title;
  final String? description;
  final String duration;
  final String status;

  AddTaskEvent(
      {required this.title,
      required this.duration,
      required this.status,
      this.description});
  @override
  List<Object> get props => throw UnimplementedError();
}
