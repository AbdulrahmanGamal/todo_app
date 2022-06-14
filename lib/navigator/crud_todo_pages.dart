import 'package:flutter/material.dart';
import 'package:todo_app/navigator/crud_todo_transition_route.dart';
import 'package:todo_app/ui/form_todo_view.dart';
import 'package:todo_app/ui/todo_list_view.dart';
import 'package:todo_app/ui/unknown_view.dart';


class TodoPage extends Page<void> {
  TodoPage({ required this.onGoToTodo})
      : super(key: ValueKey('TodoPage'));

  final NavigatorToTodo onGoToTodo;

  @override
  Route<void> createRoute(BuildContext context) {
    return FadeTransitionRoute(
      settings: this,
      child: TodoListView(onGoToTodo: onGoToTodo),
    );

    /// Uncomment it and comment code above to use individually
    // return PageRouteBuilder<void>(
    //   settings: this,
    //   transitionDuration: const Duration(milliseconds: 1000),
    //   pageBuilder: (context, animation, animation2) {
    //     return FadeTransition(
    //       opacity: animation,
    //       child: TodoListView(
    //         categoryId: categoryId,
    //         onGoToTodo: onGoToTodo,
    //       ),
    //     );
    //   },
    // );

    /// Uncomment it and comment code above to use individually
    // return MaterialPageRoute<void>(
    //   settings: this,
    //   builder: (_) => TodoListView(
    //     categoryId: categoryId,
    //     onGoToTodo: onGoToTodo,
    //   ),
    // );
  }
}

class FormTodoPage extends Page<void> {
  FormTodoPage({ this.todoId})
      : super(key: ValueKey('FormTodoPage_${todoId ?? 'none'}'));

  final String? todoId;

  @override
  Route<void> createRoute(BuildContext context) {
    return SlideTransitionRoute(
      settings: this,
      child: FormTodoView( todoId: todoId),
    );

    /// Uncomment it and comment code above to use individually
    // return PageRouteBuilder<void>(
    //   settings: this,
    //   reverseTransitionDuration: const Duration(milliseconds: 1000),
    //   transitionDuration: const Duration(milliseconds: 1000),
    //   pageBuilder: (context, animation, animation2) {
    //     final tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
    //     final curveTween = CurveTween(curve: Curves.easeInOut);
    //
    //     return SlideTransition(
    //       position: animation.drive(curveTween).drive(tween),
    //       child: FormTodoView(categoryId: categoryId, todoId: todoId),
    //     );
    //   },
    // );

    /// Uncomment it and comment code above to use individually
    // return MaterialPageRoute<void>(
    //   settings: this,
    //   builder: (_) => FormTodoView(categoryId: categoryId, todoId: todoId),
    // );
  }
}

class UnknownPage extends Page<void> {
  const UnknownPage() : super(key: const ValueKey('UnknownPage'));

  @override
  Route<void> createRoute(BuildContext context) {
    return ScaleTransitionRoute(
      settings: this,
      child: const UnknownView(),
    );

    /// Uncomment it and comment code above to use individually
    // return PageRouteBuilder<void>(
    //   settings: this,
    //   reverseTransitionDuration: const Duration(milliseconds: 1000),
    //   transitionDuration: const Duration(milliseconds: 1000),
    //   pageBuilder: (context, animation, animation2) {
    //     return ScaleTransition(
    //       scale: animation,
    //       child: const UnknownView(),
    //     );
    //   },
    // );

    /// Uncomment it and comment code above to use individually
    // return MaterialPageRoute<void>(
    //   settings: this,
    //   builder: (_) => const UnknownView(),
    // );
  }
}
