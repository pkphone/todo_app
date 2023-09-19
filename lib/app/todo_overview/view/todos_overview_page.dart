import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/todo_overview/bloc/todos_overview_bloc.dart';
import 'package:todo_app/app/todo_overview/widgets/todo_list_tile.dart';
import 'package:todo_app/edit_todo/view/edit_todo_page.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do list'),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create to-do.'),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'Empty to-do list',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final todo in state.filteredTodos)
                    TodoListTile(
                      todo: todo,
                      onToggleCompleted: (isCompleted) {
                        context.read<TodosOverviewBloc>().add(
                              TodosOverviewTodoCompletionToggled(
                                todo: todo,
                                isCompleted: isCompleted,
                              ),
                            );
                      },
                      onDismissed: (_) {
                        context
                            .read<TodosOverviewBloc>()
                            .add(TodosOverviewTodoDeleted(todo));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditTodoPage.route(initialTodo: todo),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
