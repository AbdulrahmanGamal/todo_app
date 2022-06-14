import 'package:dart_emoji/dart_emoji.dart';
import 'package:todo_app/model/todo_model.dart';


const todoId = 'TODO-456';
const todoSubject = 'Test TODO';
final todoInitialDate = DateTime.now();
final todoFinalDate = DateTime.now().add(const Duration(days: 10));
final todoExpiredDate = DateTime.now().add(const Duration(days: -1));
final todoTodayDate = DateTime.now().add(const Duration(minutes: 30));

Todo get initialTodo => Todo(
      finalDate: todoInitialDate,
      subject: todoSubject,
    );

Todo get existingTodo => Todo(
      id: todoId,
      finalDate: todoFinalDate,
      subject: todoSubject,
    );

Todo get expiredTodo => Todo(
      id: todoId,
      finalDate: todoExpiredDate,
      subject: todoSubject,
    );

Todo get todayTodo => Todo(
      id: todoId,
      finalDate: todoTodayDate,
      subject: todoSubject,
    );
