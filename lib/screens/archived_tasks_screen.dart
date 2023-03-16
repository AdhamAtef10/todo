import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_cubit.dart';
import 'package:todo/screens/components/task_components.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoState>(
      listener: (context, state) {},
      builder: (context, state) {
        var archivedTasks=TodoCubit.get(context).archivedTasks;
        return taskBuilder(
          task: archivedTasks!
        );
      },
    );
  }
}
