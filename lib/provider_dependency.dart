import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/navigator/crud_todo_router_delegate.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/service/todo_service.dart';

import 'navigator/crud_todo_information_parser.dart';
import 'viewmodel/todo/todo_state.dart';
import 'viewmodel/todo/todo_view_model.dart';

//region Firebase Firestore
final firestorePod = Provider((_) => FirebaseFirestore.instance);
//endregion

//region Service layer

final todoServicePod = Provider<TodoService>((ref) {
  return TodoService(ref.read(firestorePod));
});
//endregion

//region Repository layer

final todoRepositoryPod = Provider<ITodoRepository>(
  (ref) => TodoRepository(ref.read(todoServicePod)),
);
//endregion


//region ViewModel layer
final todoViewModelPod = StateNotifierProvider<TodoViewModel, TodoState>(
  (ref) => TodoViewModel(ref.watch(todoRepositoryPod)),
);
//endregion

//region Navigator 2.0

final crudTodoRouterDelegateProvider = ChangeNotifierProvider(
  (_) => CrudTodoRouterDelegate(),
);

final crudTodoInformationParserProvider = Provider(
  (ref) => CrudTodoInformationParser(),
);

//endregion
