import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_/core/constants/utils.dart';
import 'package:frontend_/features/home/repository/task_local_repository.dart';
import 'package:frontend_/features/home/repository/task_remote_repository.dart';
import 'package:frontend_/models/task_model.dart';

part 'task_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
          title: title,
          uid: uid,
          description: description,
          hexColor: rgbToHex(color),
          token: token,
          dueAt: dueAt);

      await taskLocalRepository.insertTask(taskModel);

      emit(AddNewTaskSuccess(taskModel));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(
        token: token,
      );
      print("this is token - {$token}");

      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncTasks(String token) async {
    final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();
    if (unsyncedTasks.isEmpty) {
      return;
    }
    print(unsyncedTasks);

    final isSynced =
        await taskRemoteRepository.syncTask(token: token, tasks: unsyncedTasks);

    if (isSynced) {
      for (final task in unsyncedTasks) {
        taskLocalRepository.updatedRowValue(task.id, 1);
      }
    }
  }
}
