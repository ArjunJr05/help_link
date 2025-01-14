import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hack/login/services/todo.dart';

/// Creates a [TodoList].
///
/// We are using [StateNotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList(const [
    Todo(id: '0', description: 'hey there :)'),
  ]);
});

/// Enum with possible filters of the `todo` list.
enum TodoListFilter {
  all,
  active,
  completed,
}

/// The currently active filter.
///
/// Notice we are using [StateProvider] here as there.
/// It's just a single value so there is no logic to be implemented.
final todoListFilter = StateProvider((_) => TodoListFilter.all);

/// The number of uncompleted todos
///
/// We are using [Provider].
/// There are a number of advantages, mainly this value being cached,
/// even if multiple widgets are reading this value - it will only be computed once.
///
/// This will also optimise unneeded rebuilds if the todo-list changes, but the
/// number of uncompleted todos doesn't (such as when editing a todo).
final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});

/// The list of todos after applying a [todoListFilter].
///
/// This too uses [Provider], to avoid recomputing.
/// It only re-calculates if either the `filter` or `todos`list updates.
final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});

/// A provider which exposes the [Todo] displayed by a [TodoItem].
///
/// By retrieving the [Todo] through a provider instead of through its
/// constructor, this allows [TodoItem] to be instantiated using the `const` keyword.
///
/// This encapuslation ensures that when adding/removing/editing todos,
/// only what the impacted widgets rebuilds, instead of the entire list of items.
final currentTodo = Provider<Todo>((ref) => throw UnimplementedError());
