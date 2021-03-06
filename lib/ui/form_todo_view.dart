
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/common/extension.dart';
import 'package:todo_app/provider_dependency.dart';
import 'package:todo_app/viewmodel/todo/todo_provider.dart';

import '../model/todo_model.dart';
import '../model/validation_text_model.dart';
import '../viewmodel/todo/todo_state.dart';

class FormTodoView extends HookConsumerWidget {
  const FormTodoView({super.key,  this.todoId});

  final String? todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoData = ref.watch(todoDetailPod('"todoId",${todoId ?? ''}'));

    final isValid = ref.watch(validationTodoProvider);

    ref.listen(
      todoViewModelPod,
      (_, TodoState state) => _onChangeState(context, state),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          todoId == null ? 'New Task' : 'Update Task',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: todoData.when(
        data: (todo) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              SubjectTodo(todo: todo).paddingSymmetric(h: 30, v: 30),
              DateTodo(todo: todo).paddingSymmetric(h: 30, v: 20),
              SubmitTodo(
                todoId: todo?.id,
                onSubmit: isValid
                    ? () {
                  ref.read(todoViewModelPod.notifier).saveTodo(
                    ref.read(subjectTodoPod.notifier).state.text!,
                    ref.read(dateTodoPod.notifier).state,
                    todoId: todoId,
                  );
                }
                    : null,
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void _onChangeState(BuildContext context, TodoState state) {
    final action = state.maybeWhen(success: (a) => a, orElse: () => null);
    if (action == TodoAction.add || action == TodoAction.update) {
      Navigator.pop(context);
    }
  }
}

class SubjectTodo extends HookConsumerWidget {
  const SubjectTodo({super.key, required this.todo});

  final Todo? todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectTodoPod.notifier);
    final subjectTextController = useTextEditingController();

    useEffect(
      () {
        if (todo != null) {
          Future.microtask(() {
            ref.read(subjectTodoPod.notifier).state =
                ValidationText(text: todo!.subject);
            subjectTextController.text = todo!.subject;
          });
        }
        return null;
      },
      const [],
    );

    return TextField(
      controller: subjectTextController,
      maxLines: 5,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'What are you planning?',
        hintStyle: const TextStyle(color: Colors.grey),
        errorText: subject.state.message,
      ),
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
      onChanged: (val) => subject.state =
          ref.read(todoViewModelPod.notifier).onChangeSubject(val),
    );
  }
}

class DateTodo extends HookConsumerWidget {
  const DateTodo({super.key, required this.todo});

  final Todo? todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finalDate = ref.watch(dateTodoPod.notifier);

    final platform = foundation.defaultTargetPlatform;

    final isIOS = platform == foundation.TargetPlatform.iOS;
    final isMacOS = platform == foundation.TargetPlatform.macOS;

    useEffect(
      () {
        if (todo != null) {
          Future.microtask(
            () => ref.read(dateTodoPod.notifier).state = todo!.finalDate,
          );
        }
        return null;
      },
      const [],
    );

    return InkWell(
      onTap: () {
        !foundation.kIsWeb && (isIOS || isMacOS)
            ? _dateIOS(context, finalDate)
            : _dateAndroid(context, finalDate);
      },
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.notifications_active_outlined,
            color: Color(0xFF4A78FA),
          ).paddingOnly(r: 12),
          Text(
            finalDate.state.dateTimeToFormattedString,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> _dateAndroid(
    BuildContext context,
    StateController<DateTime> date,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: date.state.isDurationNegative
          ? DateTime.now().add(const Duration(minutes: 2))
          : date.state.add(const Duration(minutes: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (_, child) {
        if (foundation.kIsWeb) {
          return Center(child: SizedBox(width: 500, height: 500, child: child));
        }

        return child!;
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date.state),
      );

      if (pickedTime != null) {
        date.state = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  void _dateIOS(BuildContext context, StateController<DateTime> date) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: cupertino.SizedBox(
            height: MediaQuery.of(context).size.height / 4.5,
            child: cupertino.DefaultTextStyle(
              style: const TextStyle(fontSize: 22),
              child: cupertino.CupertinoDatePicker(
                initialDateTime: date.state.isDurationNegative
                    ? DateTime.now().add(const Duration(minutes: 2))
                    : date.state.add(const Duration(minutes: 2)),
                minimumDate: DateTime.now(),
                maximumDate: DateTime.now().add(const Duration(days: 365)),
                onDateTimeChanged: (pickedDate) => date.state = pickedDate,
              ),
            ),
          ),
        ).paddingAll(10);
      },
    );
  }
}

class SubmitTodo extends HookConsumerWidget {
  const SubmitTodo({
    super.key,
    this.todoId,
    this.onSubmit,
  });

  final String? todoId;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: const Color(0xFF4A78FA)),
      onPressed: onSubmit,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          todoId == null ? 'Create' : 'Update',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ).paddingSymmetric(v: 16),
    );
  }
}
