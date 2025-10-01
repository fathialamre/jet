# Riverpod Mutations - Roadmap for Jet Framework

## 📋 Summary

Yes, **Mutations** is a new experimental feature in Riverpod! However, it's **not yet available** in the current stable releases.

## ⚠️ Current Status

- **Riverpod Version in Jet**: `3.0.0`
- **Mutations Availability**: ❌ Not in stable release yet
- **Status**: Experimental / Coming Soon
- **Documentation**: ✅ [Available on Riverpod docs](https://riverpod.dev/docs/concepts2/mutations)

## 🔍 What We Discovered

### About Mutations

According to the [Riverpod documentation](https://riverpod.dev/docs/concepts2/mutations), Mutations are designed to:

1. **Handle Async Operations** - Clean way to manage loading/error/success states
2. **Avoid State Pollution** - Keep UI concerns separate from business logic
3. **Simplify Common Patterns** - Form submissions, delete operations, toggles, etc.

### The Four States

```dart
MutationIdle      // Not started or reset
MutationPending   // Operation in progress  
MutationError     // Operation failed
MutationSuccess   // Operation succeeded with result
```

### Key Features

- ✅ **Scoped Mutations** - Different instances per item (e.g., delete by ID)
- ✅ **Auto Cleanup** - Reset to idle when completed or unmounted
- ✅ **Transaction API** - Access providers via `tsx.get()`
- ✅ **Type Safety** - Generic return types

## 🎯 How It Compares to Jet Patterns

### Current: JetFormNotifier

```dart
// Complex but powerful
class LoginFormNotifier extends JetFormNotifier<LoginRequest, User> {
  @override
  LoginRequest decoder(Map<String, dynamic> formData) => 
    LoginRequest.fromJson(formData);

  @override
  Future<User> action(LoginRequest data) async {
    final auth = ref.read(authServiceProvider);
    return await auth.login(data.email, data.password);
  }
}

final loginFormProvider = JetFormProvider<LoginRequest, User>(
  (ref) => LoginFormNotifier(ref),
);
```

### Future: Mutations (Simpler)

```dart
// When available - much simpler!
final loginMutation = JetMutation<User>();

// In widget
loginMutation.run(ref, (tsx) async {
  final auth = tsx.get(authServiceProvider);
  return await auth.login(email, password);
});
```

## 📅 Integration Timeline

### Phase 1: Monitor Riverpod Releases
- Track Riverpod updates for Mutations release
- Test in development when available
- Validate API stability

### Phase 2: Jet Integration (When Available)
- Create `JetMutation` wrapper with enhanced helpers
- Add extension methods for common patterns
- Build `JetMutationButton` component
- Update documentation with examples

### Phase 3: Migration Tools
- Provide migration guide from JetFormNotifier
- Create comparison documentation
- Build code generation tools
- Add IDE snippets

## 🚀 Future Use Cases in Jet

### 1. Simple Form Submissions
```dart
final submitFormMutation = JetMutation<Result>();

// Simpler than JetFormNotifier for basic forms
submitFormMutation.run(ref, (tsx) async {
  final api = tsx.get(apiProvider);
  return await api.submit(formData);
});
```

### 2. Delete Operations
```dart
final deleteTodoMutation = JetMutation<void>();

// Scoped per item
deleteTodoMutation(todoId).run(ref, (tsx) async {
  final api = tsx.get(apiProvider);
  await api.deleteTodo(todoId);
});
```

### 3. Like/Unlike Toggles
```dart
final toggleLikeMutation = JetMutation<bool>();

// Returns new state
final newState = await toggleLikeMutation(postId).run(ref, (tsx) async {
  final api = tsx.get(apiProvider);
  return await api.toggleLike(postId);
});
```

### 4. Batch Operations
```dart
final batchUpdateMutation = JetMutation<int>();

// Track progress of batch operations
batchUpdateMutation.run(ref, (tsx) async {
  final api = tsx.get(apiProvider);
  return await api.batchUpdate(selectedIds);
});
```

## 💡 Recommendations

### For Now: Continue Using Current Patterns

1. **Complex Forms** → Use `JetFormNotifier` (full-featured)
2. **Simple Actions** → Use `AsyncValue` with providers
3. **Delete Operations** → Use custom notifiers or callbacks

### When Mutations Arrive

1. **Simple Forms** → Migrate to `JetMutation`
2. **Action Buttons** → Use `JetMutationButton` component
3. **Item Operations** → Use scoped mutations
4. **Complex Forms** → Keep `JetFormNotifier` (more powerful)

## 📚 Resources

- [Riverpod Mutations Docs](https://riverpod.dev/docs/concepts2/mutations)
- [Jet Forms Documentation](./.features_docs/05_forms_system.md)
- [Mutations Integration Plan](./.features_docs/09_mutations_integration.md)

## ✅ Action Items

### Immediate
- [x] Research Mutations feature
- [x] Document current status
- [x] Create integration plan
- [x] Identify use cases

### When Available
- [ ] Update Riverpod to version with Mutations
- [ ] Implement `JetMutation` wrapper
- [ ] Create helper extensions
- [ ] Build example components
- [ ] Write migration guide
- [ ] Update documentation

## 🔗 Tracking

Monitor these for Mutations release:
- [Riverpod GitHub Releases](https://github.com/rrousselGit/riverpod/releases)
- [Riverpod Changelog](https://pub.dev/packages/riverpod/changelog)
- [Riverpod Discord](https://discord.gg/Rbr7PNPNr9)

---

## Conclusion

Mutations are an **exciting upcoming feature** that will:
- ✅ Simplify async operation handling
- ✅ Reduce boilerplate for simple actions  
- ✅ Complement existing Jet patterns
- ✅ Provide cleaner UI state management

**However**, they're **not available yet** in stable Riverpod. The Jet framework will integrate Mutations as soon as they're released in a stable version.

For detailed examples and integration patterns (ready for when Mutations arrive), see [`.features_docs/09_mutations_integration.md`](./.features_docs/09_mutations_integration.md).

