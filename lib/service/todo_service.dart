import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/common/extension.dart';

import '../model/todo_model.dart';

class TodoService {
  TodoService(this._database);

  late final FirebaseFirestore _database;

  static const String _todoCollection = 'todos';

  Stream<List<Todo>> getTodos() {
    final querySnapshot = _database
        .collection(_todoCollection)
        .snapshots();

    return querySnapshot.map(
      (query) => [for (var item in query.docs) Todo.fromJson(item.toMap())],
    );
  }

  Future<Todo> getTodoById(String todoId) async {
    final todoCollection = _database.collection(_todoCollection);
    final todoDocument = await todoCollection.doc(todoId).get();

    if (todoDocument.exists) {
      final todoMap = todoDocument.toMap();
      return Todo.fromJson(todoMap);
    }

    throw Exception('Oops!!! Todo not found');
  }

  Future<void> saveTodo(Todo todo) async {
    if (todo.id != null) {
      await _database
          .collection(_todoCollection)
          .doc(todo.id)
          .update(todo.toJson());
    } else {
      await _database.collection(_todoCollection).add(todo.toJson());
    }
  }

  Future<void> deleteTodo(String todoId) async {
    await _database.collection(_todoCollection).doc(todoId).delete();
  }
}
