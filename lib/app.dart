import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_size/window_size.dart';

import 'common/adaptive_contextual_layout.dart';
import 'provider_dependency.dart';
import 'dart:html' as html;

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _todoRouterDelegate = ref.watch(crudTodoRouterDelegateProvider);
    final _todoInfoParser = ref.watch(crudTodoInformationParserProvider);
    html.document.body!
        .addEventListener('contextmenu', (event) => event.preventDefault());

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      onGenerateTitle: (ctx) {
        if (getDevice() == DeviceSegment.desktop) setWindowTitle(title);
        return title;
      },
      routerDelegate: _todoRouterDelegate,
      routeInformationParser: _todoInfoParser,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
