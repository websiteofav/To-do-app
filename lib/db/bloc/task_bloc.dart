import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:to_do_list/db/model/task_model.dart';
import 'package:bloc/bloc.dart';
import 'package:to_do_list/db/repository/task_database.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskDatabase repository;
  TaskBloc({required this.repository}) : super(TaskInitial()) {
    on<GetTaskEvent>((event, emit) async {
      emit(TaskLoadingState());

      try {
        TaskModel model = await repository.getTask(event.id);

        GetTaskSuccessState(model: model);
      } catch (e) {
        emit(TaskfailureState(errorMessage: e.toString()));
      }
    });

    on<GetAllTaskEvent>((event, emit) async {
      emit(TaskLoadingState());

      try {
        List<TaskModel> model = await repository.getAllTask();

        emit(GetAllTaskSuccessState(model: model));
      } catch (e) {
        emit(TaskfailureState(errorMessage: e.toString()));
      }
    });
    on<AddTaskEvent>((event, emit) async {
      emit(TaskLoadingState());

      try {
        TaskModel jsonRequest = TaskModel(
            duration: event.duration,
            title: event.title,
            status: event.status,
            description: event.description);

        TaskModel model = await repository.create(jsonRequest);

        emit(GetTaskSuccessState(model: model));
      } catch (e) {
        emit(TaskPopUpfailureState(errorMessage: e.toString()));
      }
    });
    on<UpdateTaskEvent>((event, emit) async {
      emit(TaskLoadingState());

      try {
        TaskModel jsonRequest = TaskModel(
          status: event.model.status,
          duration: event.model.duration,
          title: event.model.title,
          description: event.model.description,
          id: event.model.id,
        );

        await repository.updateTask(jsonRequest);

        emit(UpdateTaskSuccessState(status: jsonRequest.status == 'DONE'));
      } catch (e) {
        emit(TaskPopUpfailureState(errorMessage: e.toString()));
      }
    });
    on<DeleteTaskEvent>((event, emit) async {
      emit(TaskLoadingState());

      try {
        await repository.delete(event.id);

        emit(DeleteTaskSuccessState());
      } catch (e) {
        emit(TaskPopUpfailureState(errorMessage: e.toString()));
      }
    });
  }
}
