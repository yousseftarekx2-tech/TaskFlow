import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';

import 'app.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => TaskBloc(),
      child: const TaskFlowApp(),
    ),
  );
}