part of 'task_bloc.dart';

@immutable
abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoadingState extends TaskState {}

class GetTaskSuccessState extends TaskState {
  final TaskModel model;

  const GetTaskSuccessState({required this.model});
}

class GetAllTaskSuccessState extends TaskState {
  final List<TaskModel> model;

  const GetAllTaskSuccessState({required this.model});
}

class AddTaskSuccessState extends TaskState {
  const AddTaskSuccessState();
}

class UpdateTaskSuccessState extends TaskState {
  final bool status;
  const UpdateTaskSuccessState({required this.status});
}

class DeleteTaskSuccessState extends TaskState {
  const DeleteTaskSuccessState();
}

class TaskPopUpfailureState extends TaskState {
  final String errorMessage;
  const TaskPopUpfailureState({required this.errorMessage});
}

class TaskfailureState extends TaskState {
  final String errorMessage;
  const TaskfailureState({required this.errorMessage});
}
