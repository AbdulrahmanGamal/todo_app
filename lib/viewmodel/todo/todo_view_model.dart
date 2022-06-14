
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/common/utils.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/model/validation_text_model.dart';
import 'package:todo_app/repository/todo_repository.dart';

import 'todo_state.dart';

class TodoViewModel extends StateNotifier<TodoState> {
  TodoViewModel(this._repository) : super(const TodoState.initial());

  late final ITodoRepository _repository;

  ValidationText onChangeSubject(String value) => Utils.validateEmpty(value);

  Future<void> saveTodo(
    String subject,
    DateTime date, {
    String? todoId,
  }) async {
    try {
      state = const TodoState.loading();

      await _repository.saveTodo(
        Todo(id: todoId, subject: subject, finalDate: date),
      );

      if (todoId == null) {
        state = const TodoState.success(TodoAction.add);
      } else {
        state = const TodoState.success(TodoAction.update);
      }
    } catch (e) {
      state = TodoState.error(e.toString());
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      state = const TodoState.loading();
      await _repository.deleteTodo(todoId);
      state = const TodoState.success(TodoAction.remove);
    } catch (e) {
      state = TodoState.error(e.toString());
    }
  }

  Future<void> checkTodo(Todo todo, {bool isChecked = false}) async {
    try {
      state = const TodoState.loading();
      await _repository.saveTodo(
        todo.copyWith(isCompleted: isChecked),
      );
      state = const TodoState.success(TodoAction.check);
    } catch (e) {
      state = TodoState.error(e.toString());
    }
  }
}
