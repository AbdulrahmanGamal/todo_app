import 'package:freezed_annotation/freezed_annotation.dart';

part 'crud_todo_config.freezed.dart';

@freezed
class CrudTodoConfig with _$CrudTodoConfig {

  const factory CrudTodoConfig.todoList() =CrudTodoConfigTodoList;

  const factory CrudTodoConfig.addTodo() = CrudTodoConfigAddTodo;

  const factory CrudTodoConfig.updateTodo(String todoId) =CrudTodoConfigUpdateTodo;

  const factory CrudTodoConfig.unknown() = CrudTodoConfigUnknown;
}
