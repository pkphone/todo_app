part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
  });

  final TodosOverviewStatus status;
  final List<Todo> todos;

  Iterable<Todo> get filteredTodos => todos;

  TodosOverviewState copyWith({
    TodosOverviewStatus Function()? status,
    List<Todo> Function()? todos,
  }) {
    return TodosOverviewState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
      ];
}
