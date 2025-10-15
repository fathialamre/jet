# Helpers Documentation

Complete guide to utility helpers in the Jet framework.

## Overview

Jet provides helper utilities for common development tasks, primarily focused on test data generation and development productivity. These helpers are designed to speed up development and testing without requiring external dependencies.

**Packages Used:**
- Dart SDK - Core utilities and random number generation

**Key Benefits:**
- ✅ Realistic test data generation
- ✅ No external API dependencies
- ✅ Consistent data formatting
- ✅ Perfect for UI development and demos
- ✅ Lightweight with no external packages
- ✅ Fast and deterministic
- ✅ Easy to extend for custom data types

## JetFaker - Test Data Generation

Generate realistic fake data for development and testing.

### Generate Random Usernames

```dart
// Generate random usernames
final username1 = JetFaker.username(); // Example: "brave_tiger123"
final username2 = JetFaker.username(); // Example: "cool_panda456"
final username3 = JetFaker.username(); // Example: "fast_eagle789"
```

### Use in Development

```dart
class DevTools {
  static User createTestUser() {
    return User(
      username: JetFaker.username(),
      email: '${JetFaker.username()}@example.com',
      createdAt: DateTime.now(),
    );
  }

  static List<User> generateTestUsers(int count) {
    return List.generate(
      count,
      (index) => createTestUser(),
    );
  }
}

// Populate test data
final testUsers = DevTools.generateTestUsers(10);
```

### Use in UI Previews

```dart
class UserCardPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final demoUser = User(
      username: JetFaker.username(),
      email: '${JetFaker.username()}@test.com',
    );
    
    return UserCard(user: demoUser);
  }
}
```

### Use in Tests

```dart
void main() {
  group('User Widget Tests', () {
    test('displays user information correctly', () {
      final testUser = User(
        username: JetFaker.username(),
        email: '${JetFaker.username()}@test.com',
      );
      
      // Test with generated data
      expect(testUser.username, isNotEmpty);
      expect(testUser.email, contains('@'));
    });
  });
}
```

## JetFaker Features

- ✅ Random username generation - Adjective + noun + number pattern
- ✅ Consistent formatting - Professional-looking test data
- ✅ Perfect for development - UI development, demos, testing
- ✅ Lightweight - No external dependencies

## Best Practices

### 1. Use for Development Only

```dart
// Good - only in debug mode
if (kDebugMode) {
  final testUsers = DevTools.generateTestUsers(10);
}

// Avoid - using in production
final users = JetFaker.generateUsers(); // Don't do this
```

### 2. Generate Realistic Data

```dart
// Good - realistic user data
final user = User(
  username: JetFaker.username(),
  email: '${JetFaker.username()}@test.com',
  createdAt: DateTime.now(),
);

// Avoid - obvious fake data
final user = User(
  username: 'test123',
  email: 'test@test.com',
);
```

### 3. Use in Storybook/Widgetbook

```dart
class UserCardStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          final user = User(
            username: JetFaker.username(),
            email: '${JetFaker.username()}@test.com',
          );
          return UserCard(user: user);
        },
      ),
    );
  }
}
```

## See Also

- [Debugging Documentation](DEBUGGING.md)
- [Forms Documentation](FORMS.md)

