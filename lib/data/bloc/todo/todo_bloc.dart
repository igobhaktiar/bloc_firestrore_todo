import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/models.dart';
import '../../service/firestore_service.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FireStoreService _fireStoreService;


  TodoBloc(this._fireStoreService) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      try {
        emit(TodoLoading());
        final todos = await _fireStoreService.getTodos().first;
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError('Error loading todos'));
      }
    });

    on<AddTodo> ((event, emit) async {
      try {
        emit(TodoLoading());
        await _fireStoreService.addTodo(event.todo);
        emit(TodoOperationSuccess('Todo added!'));
      } catch (e) {
        emit(TodoError('Error adding todo'));
      }
    });

    on<UpdateTodo> ((event, emit) async {
      try {
        emit(TodoLoading());
        await _fireStoreService.updateTodo (event.todo);
        emit(TodoOperationSuccess('Todo updated!'));
      } catch (e) {
        emit(TodoError('Error updating todo'));
      }
    });

    on<DeleteTodo> ((event, emit) async {
      try {
        emit(TodoLoading());
        await _fireStoreService.deleteTodoById (event.id);
        emit(TodoOperationSuccess('Todo deleted!'));
      } catch (e) {
        emit(TodoError('Error deleting todo'));
      }
    });
  }
}
