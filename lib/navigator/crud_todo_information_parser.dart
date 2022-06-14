import 'package:flutter/material.dart';
import 'package:todo_app/navigator/config/crud_todo_config.dart';

class CrudTodoPath {
  static const category = 'categories';
  static const todo = 'todo';
  static const unknown = '404';
}
// Category detail '/todos/{id}'
class CrudTodoInformationParser extends RouteInformationParser<CrudTodoConfig> {
  // @override
  // Future<CrudTodoConfig> parseRouteInformation(
  //   RouteInformation routeInformation,
  // ) async {
  //   final uri = Uri.parse(routeInformation.location ?? '');
  //
  //   if (uri.pathSegments.isEmpty) {
  //     return const CrudTodoConfigTodoList();
  //   } else if (uri.pathSegments.length == 1) {
  //     // Home '/categories'
  //     return const CrudTodoConfigTodoList();
  //
  //   } else if (uri.pathSegments.length == 2) {
  //     // Category detail '/categories/{id}'
  //     final firstSegment = uri.pathSegments[0].toLowerCase();
  //     final secondSegment = uri.pathSegments[1];
  //
  //     if (firstSegment == CrudTodoPath.category) {
  //       if (secondSegment.isNotEmpty) {
  //         return CrudTodoConfigUpdateTodo(secondSegment);
  //       }
  //     }
  //
  //
  //   return const CrudTodoConfig.unknown();
  // }

  @override
  RouteInformation? restoreRouteInformation(CrudTodoConfig configuration) {
    return configuration.when(
      todoList: () {
        const todoPath = CrudTodoPath.todo;
        return RouteInformation(location: '/$todoPath');
      },
      addTodo: () {
        const todoPath = CrudTodoPath.todo;
        return RouteInformation(location: '/$todoPath/');
      },
      updateTodo: (todoId) {
        const todoPath = CrudTodoPath.todo;
        return RouteInformation(location: '/$todoPath/$todoId');
      },
      unknown: () {
        return const RouteInformation(location: '/${CrudTodoPath.unknown}');
      },
    );
  }

  @override
  Future<CrudTodoConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    if (uri.pathSegments.isEmpty) {
          return const CrudTodoConfigTodoList();
        } else if (uri.pathSegments.length == 1) {
          // Home '/todos'
          return const CrudTodoConfigTodoList();
        }else if (uri.pathSegments.length == 2) {
      // TODOs detail '/todos/{id}'
      final firstSegment = uri.pathSegments[0].toLowerCase();
      final secondSegment = uri.pathSegments[1];
      if (firstSegment == CrudTodoPath.category) {
        if (secondSegment.isNotEmpty) {
          return CrudTodoConfigUpdateTodo(secondSegment);
        }
      }

    }
    return const CrudTodoConfig.unknown();
  }
}
