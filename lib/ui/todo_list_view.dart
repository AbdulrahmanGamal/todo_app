import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/common/extension.dart';

import '../common/adaptive_contextual_layout.dart';
import '../model/todo_model.dart';
import '../provider_dependency.dart';
import '../viewmodel/todo/todo_provider.dart';
import '../viewmodel/todo/todo_state.dart';
import 'widgets/todo_item.dart';

typedef NavigatorToTodo = void Function(String?);

class TodoListView extends HookConsumerWidget {
  const TodoListView({
    super.key,
    required this.onGoToTodo,
  });

  final NavigatorToTodo onGoToTodo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoListPod(""));
    ref.listen(
      todoViewModelPod,
      (_, TodoState state) => _onChangeState(context, state),
    );

    return ContextMenuOverlay(
      child: Scaffold(
          backgroundColor: const Color(0xFF4A78FA),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              onGoToTodo.call(null);
            },
            icon: Icon(Icons.add),
            label: Text("Add New Note"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: todoData.when(
                  data: (data) {
                    return DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: data.isNotEmpty
                          ? TodoList(
                              todoList: data,
                              onEditItem: (todo) => onGoToTodo(todo.id),
                            ).paddingSymmetric(h: 24, v: 20)
                          : const Center(
                              child: Text(
                                'Empty data, add a task',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _onChangeState(BuildContext context, TodoState state) {
    final action = state.maybeWhen(success: (a) => a, orElse: () => null);
    final error = state.maybeWhen(error: (m) => m, orElse: () => null);

    if (action != null) {
      if (action == TodoAction.add) {
        _showMessage(context, 'Todo created successfully');
      } else if (action == TodoAction.update) {
        _showMessage(context, 'Todo updated successfully');
      } else if (action == TodoAction.remove) {
        _showMessage(context, 'Todo removed successfully');
      } else if (action == TodoAction.check) {
        _showMessage(context, 'Todo finished successfully');
      }
    }

    if (error != null) _showMessage(context, error);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({super.key, required this.todoList, required this.onEditItem});

  final List<Todo> todoList;
  final ValueSetter<Todo> onEditItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(todoViewModelPod.notifier);

    final isDesktop = [
      DeviceSegment.desktop,
      DeviceSegment.desktopWeb,
    ].contains(getDevice());

    return ListView(
      children: <Widget>[
        for (final item in todoList)
          if (isDesktop)
            TodoItem.contextual(
              todo: item,
              onEdit: () => onEditItem(item),
              onRemove: () => viewModel.deleteTodo(item.id!),
              onCheck: (value) => viewModel.checkTodo(item, isChecked: value),
            )
          else
            TodoItem(
              todo: item,
              onEdit: () => onEditItem(item),
              onRemove: () => viewModel.deleteTodo(item.id!),
              onCheck: (value) => viewModel.checkTodo(item, isChecked: value),
            )
      ],
    );
  }
}
