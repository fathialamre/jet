// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoForm)
const todoFormProvider = TodoFormFamily._();

final class TodoFormProvider
    extends
        $NotifierProvider<TodoForm, AsyncFormValue<TodoRequest, TodoResponse>> {
  const TodoFormProvider._({
    required TodoFormFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'todoFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todoFormHash();

  @override
  String toString() {
    return r'todoFormProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is TodoFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todoFormHash() => r'0c78295d9498dd9dc76c7aa8b49f3ee814682612';

final class TodoFormFamily extends $Family
    with
        $ClassFamilyOverride<
          TodoForm,
          AsyncFormValue<TodoRequest, TodoResponse>,
          AsyncFormValue<TodoRequest, TodoResponse>,
          AsyncFormValue<TodoRequest, TodoResponse>,
          int
        > {
  const TodoFormFamily._()
    : super(
        retry: null,
        name: r'todoFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TodoFormProvider call(int id) => TodoFormProvider._(argument: id, from: this);

  @override
  String toString() => r'todoFormProvider';
}

abstract class _$TodoForm
    extends $Notifier<AsyncFormValue<TodoRequest, TodoResponse>> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  AsyncFormValue<TodoRequest, TodoResponse> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
