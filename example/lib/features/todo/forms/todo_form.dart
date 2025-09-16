import 'package:example/features/todo/models/todo_request.dart';
import 'package:example/features/todo/models/todo_response.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet_framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_form.g.dart';

@riverpod
class TodoForm extends JetFormNotifier<TodoRequest, TodoResponse> {
  @override
  AsyncFormValue<TodoRequest, TodoResponse> build() {
    return const AsyncFormIdle();
  }

  @override
  TodoRequest decoder(Map<String, dynamic> json) {
    return TodoRequest.fromJson(json);
  }

  @override
  Future<TodoResponse> action(TodoRequest data) async {
    dump('Creating todo: $data');

    // Simulate API call
    await 2.sleep();

    // Return mock response
    return TodoResponse(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: data.title,
      description: data.description,
      isCompleted: data.isCompleted,
      createdAt: DateTime.now(),
    );
  }
}
