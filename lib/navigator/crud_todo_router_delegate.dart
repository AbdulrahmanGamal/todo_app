
import 'package:flutter/material.dart';
import 'package:todo_app/navigator/config/crud_todo_config.dart';
import 'package:todo_app/navigator/crud_todo_pages.dart';

class CrudTodoRouterDelegate extends RouterDelegate<CrudTodoConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CrudTodoConfig> {
  CrudTodoRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  final _heroController = HeroController();

  // Global Key
  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;



  String? _todoId;

  String? get todoId => _todoId;

  bool _isTodoSelected = false;

  bool get isTodoSelected => _isTodoSelected;

  void selectCurrentTodo(String? value, {required bool isSelected}) {
    _todoId = value;
    _isTodoSelected = isSelected;
    print("selectCurrentTodo : ${value}");
    notifyListeners();
  }

  // Current unknown page or 404 not found

  bool _is404 = false;

  bool get is404 => _is404;

  set is404(bool value) {
    _is404 = value;

    if (value) {
      _todoId = null;
      _isTodoSelected = false;
    }

    notifyListeners();
  }

  bool get isTodoList =>
      todoId == null && !isTodoSelected && !is404;

  bool get isTodoNew =>
       todoId == null && isTodoSelected && !is404;

  bool get isTodoUpdate =>
      todoId != null && isTodoSelected && !is404;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [_heroController],
      pages: <Page<void>>[
        if (is404)
          const UnknownPage()
        else ...[
          TodoPage(
              onGoToTodo: ( todoId) => selectCurrentTodo(
                todoId,
                isSelected: true,
              ),
            ),
          if (isTodoSelected)
            FormTodoPage( todoId: todoId)
        ]
      ],
      onPopPage: (route, dynamic result) {
        if (!route.didPop(result)) return false;

        selectCurrentTodo(null, isSelected: false);

        return true;
      },
    );
  }

  @override
  CrudTodoConfig? get currentConfiguration {
     if (isTodoList) {
      return CrudTodoConfigTodoList();
    } else if (isTodoNew) {
      return CrudTodoConfigAddTodo();
    } else if (isTodoUpdate) {
      return CrudTodoConfigUpdateTodo( todoId!);
    } else if (is404) {
      return const CrudTodoConfigUnknown();
    }
    return null;
  }

  @override
  Future<void> setNewRoutePath(CrudTodoConfig configuration) async =>
      configuration.when(
        todoList: () => _values(),
        addTodo: () => _values( selected: true),
        updateTodo: ( todoId) => _values(
          todoId: todoId,
          selected: true,
        ),
        unknown: () => _values(noFound: true),
      );

  void _values({String? todoId, bool? selected, bool? noFound}) {
    selectCurrentTodo(todoId, isSelected: selected ?? false);
    is404 = noFound ?? false;
  }
}
