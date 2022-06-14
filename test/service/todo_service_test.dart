
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/common/extension.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/service/todo_service.dart';

import '../test_utils/mocks.dart';
import '../test_utils/params_factory.dart';

void main() {
  late MockFirestore mockFirestoreInstance;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockQuery mockQuery;

  late TodoService todoService;

  setUpAll(() {
    mockFirestoreInstance = MockFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot(existingTodo.id!);
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot(existingTodo.id!);
    mockQuery = MockQuery();

    todoService = TodoService(mockFirestoreInstance);
  });

  group('$TodoService', () {
    test('Get $Todo list from Firebase mock', () async {
      when(() => mockFirestoreInstance.collection(any()))
          .thenReturn(mockCollectionReference);

      when(
        () => mockCollectionReference.where(
          any(),
          isEqualTo: any(named: 'isEqualTo'),
        ),
      ).thenReturn(mockQuery);

      when(() => mockQuery.snapshots())
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));

      when(() => mockQuerySnapshot.docs)
          .thenReturn([mockQueryDocumentSnapshot]);

      when(() => mockQueryDocumentSnapshot.toMap())
          .thenReturn(existingTodo.toJson());

      final result = todoService.getTodos();
      final finalResult = await result.first;

      expect(result, isA<Stream<List<Todo>>>());
      expect(finalResult, isA<List<Todo>>());
      verify(
        () => mockFirestoreInstance
            .collection(any())
            .where(any(), isEqualTo: any(named: 'isEqualTo')),
      ).called(1);
    });

    test('Get $Todo by id from Firebase mock', () async {
      when(() => mockFirestoreInstance.collection(any()))
          .thenReturn(mockCollectionReference);

      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);

      when(() => mockDocumentReference.get())
          .thenAnswer((_) => Future.value(mockDocumentSnapshot));

      when(() => mockDocumentSnapshot.exists).thenReturn(true);

      when(() => mockDocumentSnapshot.toMap())
          .thenReturn(existingTodo.toJson());

      final result = todoService.getTodoById(todoId);
      final finalResult = await result;

      expect(result, isA<Future<Todo>>());
      expect(finalResult, isA<Todo>());
      verify(() => mockFirestoreInstance.collection(any()).doc(any()))
          .called(2);
    });

    test("Get $Exception if todo by id doesn't exists", () async {
      when(() => mockFirestoreInstance.collection(any()))
          .thenReturn(mockCollectionReference);

      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);

      when(() => mockDocumentReference.get())
          .thenAnswer((_) => Future.value(mockDocumentSnapshot));

      when(() => mockDocumentSnapshot.exists).thenReturn(false);

      when(() => mockDocumentSnapshot.toMap()).thenThrow(
        Exception('Oops!!! Todo not found'),
      );

      final result = todoService.getTodoById(todoId);

      expect(result, throwsA(isA<Exception>()));
      verify(() => mockFirestoreInstance.collection(any()).doc(any()))
          .called(1);
    });

    test('Save $Todo from Firebase mock', () {
      when(() => mockFirestoreInstance.collection(any()))
          .thenReturn(mockCollectionReference);

      when(() => mockCollectionReference.add(any()))
          .thenAnswer((_) async => mockDocumentReference);

      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);

      when(() => mockDocumentReference.update(any()))
          .thenAnswer((_) => Future.value());

      final result = todoService.saveTodo(initialTodo);

      expect(result, isA<Future<void>>());
      verify(() => mockFirestoreInstance.collection(any()).add(any()))
          .called(1);
    });

    test('Update $Todo from Firebase mock', () {
      when(() => mockFirestoreInstance.collection(any()))
          .thenReturn(mockCollectionReference);

      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);

      when(() => mockDocumentReference.update(any()))
          .thenAnswer((_) => Future.value());

      final result = todoService.saveTodo(existingTodo.copyWith());

      expect(result, isA<Future<void>>());
      verify(
        () => mockFirestoreInstance.collection(any()).doc(any()).update(any()),
      );
    });

    test('Remove $Todo from Firebase mock', () {
      when(() => mockFirestoreInstance.collection(any()))
          .thenReturn(mockCollectionReference);

      when(() => mockCollectionReference.doc(any()))
          .thenReturn(mockDocumentReference);

      when(() => mockDocumentReference.delete())
          .thenAnswer((_) => Future.value());

      when(() => mockDocumentReference.update(any()))
          .thenAnswer((_) => Future.value());

      final result = todoService.deleteTodo(existingTodo.id!);

      expect(result, isA<Future<void>>());
      verify(() => mockFirestoreInstance.collection(any()).doc(any()).delete())
          .called(1);
    });
  });
}
