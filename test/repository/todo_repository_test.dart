import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/repository/todo_repository.dart';

import '../test_utils/mocks.dart';
import '../test_utils/params_factory.dart';

void main() {
  late MockTodoService mockTodoService;
  late ITodoRepository todoRepository;

  setUpAll(() {
    mockTodoService = MockTodoService();
    todoRepository = TodoRepository(mockTodoService);
    registerFallbackValue(MyTodoFake());
  });

    test(
        'should return todo '
        'when getTodoById is called', () async {
      final future = Future.value(existingTodo);
      when(() => mockTodoService.getTodoById(any()))
          .thenAnswer((_) => future);

      final result = todoRepository.getTodoById(existingTodo.id!);

      expect(result, isA<Future<Todo>>());
      expect(result, future);

      verify(() => mockTodoService.getTodoById(any()));
      verifyNoMoreInteractions(mockTodoService);
    });

    test('should save todo when saveTodo is called', () {
      when(() => mockTodoService.saveTodo(any())).thenAnswer(
        (_) => Future.value(),
      );

      final result = todoRepository.saveTodo(existingTodo);

      expect(result, isA<Future<void>>());

      verify(() => mockTodoService.saveTodo(any()));
      verifyNoMoreInteractions(mockTodoService);
    });

    test('should delete todo when deleteTodo is called', () {
      when(() => mockTodoService.deleteTodo(any())).thenAnswer(
        (_) => Future.value(),
      );

      final result = todoRepository.deleteTodo(todoId);

      expect(result, isA<Future<void>>());

      verify(() => mockTodoService.deleteTodo(any()));
      verifyNoMoreInteractions(mockTodoService);
    });
}
