// ignore: unused_import
import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/app/app.dart';
import 'package:todo_app/app/app_bloc_observer.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

void bootstrap({required TodosApi todosApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final todosRepository = TodosRepository(todosApi: todosApi);

  runApp(App(todosRepository: todosRepository));
}
