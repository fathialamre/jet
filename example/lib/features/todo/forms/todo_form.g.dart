// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoForm)
const todoFormProvider = TodoFormProvider._();

final class TodoFormProvider
    extends
        $NotifierProvider<TodoForm, AsyncFormValue<TodoRequest, TodoResponse>> {
  const TodoFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoFormHash();

  @$internal
  @override
  TodoForm create() => TodoForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncFormValue<TodoRequest, TodoResponse> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncFormValue<TodoRequest, TodoResponse>>(value),
    );
  }
}

String _$todoFormHash() => r'7a867c9c34c50a77d63c38c2ea69abaf8c73285f';

abstract class _$TodoForm
    extends $Notifier<AsyncFormValue<TodoRequest, TodoResponse>> {
  AsyncFormValue<TodoRequest, TodoResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncFormValue<TodoRequest, TodoResponse>,
              AsyncFormValue<TodoRequest, TodoResponse>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncFormValue<TodoRequest, TodoResponse>,
                AsyncFormValue<TodoRequest, TodoResponse>
              >,
              AsyncFormValue<TodoRequest, TodoResponse>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
