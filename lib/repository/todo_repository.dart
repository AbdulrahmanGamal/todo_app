import '../model/todo_model.dart';
import '../service/todo_service.dart';

abstract class ITodoRepository {
  Stream<List<Todo>> getTodos();

  Future<Todo> getTodoById(String todoId);

  Future<void> saveTodo(Todo todo);

  Future<void> deleteTodo(String todoId);
}

class TodoRepository implements ITodoRepository {
  TodoRepository(this._todoService);

  final TodoService _todoService;

  @override
  Stream<List<Todo>> getTodos() => _todoService.getTodos();

  @override
  Future<Todo> getTodoById(String todoId) => _todoService.getTodoById(todoId);

  @override
  Future<void> saveTodo(Todo todo) async => _todoService.saveTodo(todo);

  @override
  Future<void> deleteTodo(String todoId) async =>
      _todoService.deleteTodo(todoId);
}
