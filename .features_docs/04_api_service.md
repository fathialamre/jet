# API Service (JetApiService)

**Status:** Active  
**Version:** 0.0.1  
**Last Updated:** October 1, 2025

## Overview

JetApiService is an abstract HTTP client wrapper built on top of Dio that provides a type-safe, consistent API for making network requests with built-in error handling, interceptors, and response modeling.

### Key Benefits
- **Type-Safe Responses:** Generic `ResponseModel<T>` wrapper for all API calls
- **Singleton Pattern:** Efficient resource management with `getInstance()`
- **Rich HTTP Support:** All HTTP methods (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)
- **Automatic Error Handling:** Integrated with Jet's error handling system
- **Interceptor Support:** Easy integration of logging, auth, retry logic
- **Response Decoding:** Flexible decoder pattern for complex types

### Use Cases
- REST API integration
- GraphQL clients
- File uploads/downloads
- Multi-part form data
- Authenticated API calls

## Architecture

### Design Philosophy

JetApiService follows the **Repository Pattern** with these principles:

1. **Abstraction:** Hide Dio complexity behind clean interface
2. **Consistency:** All responses wrapped in `ResponseModel<T>`
3. **Flexibility:** Support any API format through custom decoders
4. **Efficiency:** Singleton pattern prevents duplicate Dio instances
5. **Integration:** Tight integration with Riverpod for DI

### Component Diagram

```
User Code
    ↓
MyApiService (extends JetApiService)
    ↓
JetApiService (abstract base)
    ↓
Dio Instance + Interceptors
    ↓
HTTP Network
```

### Key Components

#### Component 1: JetApiService (Abstract Base)
- **Location:** `packages/jet/lib/networking/jet_api.dart`
- **Purpose:** Provides HTTP method wrappers and lifecycle management
- **Key Methods:**
  - `get<T>()`: HTTP GET with typed response
  - `post<T>()`: HTTP POST with typed response
  - `put<T>()`, `delete<T>()`, `patch<T>()`: Other HTTP methods
  - `upload<T>()`: Multipart form data upload
  - `download()`: File download with progress
  - `network<T>()`: High-level wrapper with fallback support

#### Component 2: ResponseModel
- **Location:** `packages/jet/lib/networking/jet_api.dart:8-54`
- **Purpose:** Standardize API response structure
- **Properties:**
  - `data`: Typed response data
  - `success`: Success flag
  - `message`: Optional message
  - `statusCode`: HTTP status code
  - `meta`: Additional metadata

#### Component 3: Singleton Manager
- **Location:** `packages/jet/lib/networking/jet_api.dart:99-107`
- **Purpose:** Manage API service instances
- **Critical Issue:** ⚠️ Memory leak - instances never released (see Performance section)

### Data Flow

```
1. Create Service
   MyApiService.getInstance() → Singleton check → Create if needed

2. Make Request
   service.get('/users') → _dio.get() → Response

3. Handle Response
   Response → ResponseModel.fromResponse() → decoder() → ResponseModel<User>

4. Error Handling
   DioException → _handleError() → JetError (via errorHandler)
```

## Implementation Details

### Core Implementation

```dart
// 1. Define your API service
class MyApiService extends JetApiService {
  static MyApiService? _instance;

  MyApiService(super.ref);

  static MyApiService getInstance(Ref ref) {
    return JetApiService.getInstance<MyApiService>(
      'MyApiService',
      () => MyApiService(ref),
    );
  }

  @override
  String get baseUrl => 'https://api.example.com';

  @override
  Map<String, dynamic> get defaultHeaders => {
    'Content-Type': 'application/json',
    'X-API-Version': '1.0',
  };

  // Custom methods
  Future<ResponseModel<List<User>>> getUsers() async {
    return await get<List<User>>(
      '/users',
      decoder: (data) => (data as List)
          .map((json) => User.fromJson(json))
          .toList(),
    );
  }
}

// 2. Provide via Riverpod
final myApiServiceProvider = Provider<MyApiService>((ref) {
  return MyApiService.getInstance(ref);
});

// 3. Use in code
class UserRepository {
  final MyApiService api;
  
  UserRepository(this.api);
  
  Future<List<User>> fetchUsers() async {
    final response = await api.getUsers();
    if (response.success && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Failed to fetch users');
  }
}
```

### State Management

Services integrate with Riverpod for dependency injection:

```dart
// API service provider
final apiProvider = Provider<MyApiService>((ref) {
  return MyApiService(ref);
});

// Repository using the service
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(apiProvider);
  return UserRepository(api);
});

// Provider that fetches data
final usersProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.fetchUsers();
});
```

### Error Handling

Errors are caught and transformed through the Jet error system:

```dart
try {
  final response = await api.get('/users');
  return response.data;
} on DioException catch (e) {
  // Automatically handled by _handleError()
  // Converted to JetError via errorHandler.handle()
} catch (e) {
  // Generic errors also handled
}
```

## Usage Examples

### Basic GET Request

```dart
Future<ResponseModel<User>> getUser(int id) async {
  return await get<User>(
    '/users/$id',
    decoder: (data) => User.fromJson(data),
  );
}
```

### POST with Body

```dart
Future<ResponseModel<User>> createUser(UserRequest request) async {
  return await post<User>(
    '/users',
    data: request.toJson(),
    decoder: (data) => User.fromJson(data),
  );
}
```

### File Upload

```dart
Future<ResponseModel<UploadResponse>> uploadImage(File image) async {
  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      image.path,
      filename: 'upload.jpg',
    ),
  });

  return await upload<UploadResponse>(
    '/upload',
    formData,
    decoder: (data) => UploadResponse.fromJson(data),
    onSendProgress: (sent, total) {
      print('Progress: ${(sent / total * 100).toStringAsFixed(2)}%');
    },
  );
}
```

### File Download

```dart
Future<void> downloadFile(String url, String savePath) async {
  await download(
    url,
    savePath,
    onReceiveProgress: (received, total) {
      print('Downloaded: ${(received / total * 100).toStringAsFixed(2)}%');
    },
  );
}
```

### Using network() Helper

```dart
// Simplified API with automatic unwrapping
Future<User> getUser(int id) async {
  return await network<User>(
    request: () => get<User>(
      '/users/$id',
      decoder: (data) => User.fromJson(data),
    ),
    fallback: User.guest(), // Optional fallback
    throwOnError: true,
  );
}
```

### Custom Interceptors

```dart
class MyApiService extends JetApiService {
  @override
  List<Interceptor> get interceptors => [
    BearerTokenInterceptor(ref),
    RetryInterceptor(),
    CacheInterceptor(),
  ];
}
```

## Performance Considerations

### Strengths
- **Connection Pooling:** Dio handles HTTP connection reuse efficiently
- **Request Cancellation:** Support for CancelToken
- **Streaming:** Download/upload with progress callbacks
- **Response Caching:** Can integrate with cache interceptors

### Bottlenecks

⚠️ **CRITICAL: Singleton Memory Leak**
```dart
static final Map<String, JetApiService> _instances = {};
```
- Instances never removed from memory
- Each service holds ~500KB-2MB
- Accumulated memory over time

See PERFORMANCE_ANALYSIS.md for solution.

⚠️ **MEDIUM: Global CancelToken**
```dart
late final CancelToken _cancelToken;
```
- Single token for all requests
- Cancelling one request cancels ALL
- No granular control

**Solution:** Create per-request tokens

⚠️ **MEDIUM: Type Detection Anti-Pattern**
```dart
if (T == String) { ... }
```
- Runtime type checking
- Not optimized by compiler

**Solution:** Always use explicit decoders

### Optimization Tips

1. **Reuse Service Instances:**
```dart
// ✅ Good - singleton
final api = ref.watch(apiProvider);

// ❌ Bad - creates new instance
final api = MyApiService(ref);
```

2. **Use Specific Cancel Tokens:**
```dart
// Create per-request
final cancelToken = api.createCancelToken();
await api.get('/users', cancelToken: cancelToken);

// Cancel specific request
cancelToken.cancel();
```

3. **Implement Request Deduplication:**
```dart
class DeduplicationInterceptor extends Interceptor {
  final _pending = <String, Future<Response>>{};
  
  @override
  void onRequest(options, handler) {
    final key = '${options.method}:${options.path}';
    
    if (_pending.containsKey(key)) {
      // Return existing request
      return;
    }
    
    _pending[key] = // current request
    // ...
  }
}
```

### Benchmarks

| Operation | Time | Memory |
|-----------|------|--------|
| GET request (cached) | 5-20ms | ~1KB |
| GET request (network) | 100-500ms | ~10KB |
| POST with JSON | 150-600ms | ~5KB |
| File upload (1MB) | 1-5s | ~2MB |
| Service creation | <1ms | 500KB |

## Common Pitfalls

### Pitfall 1: Not Providing Decoder
**Problem:** Expecting automatic type conversion  
**Solution:** Always provide explicit decoder for complex types

```dart
// ❌ BAD
final response = await get<User>('/user/1');
// Crashes if data is Map<String, dynamic>

// ✅ GOOD
final response = await get<User>(
  '/user/1',
  decoder: (data) => User.fromJson(data),
);
```

### Pitfall 2: Forgetting to Check success Flag
**Problem:** Using data without checking if request succeeded  
**Solution:** Always check success before accessing data

```dart
// ❌ BAD
final users = response.data!; // Might be null!

// ✅ GOOD
if (response.success && response.data != null) {
  final users = response.data!;
} else {
  throw Exception(response.message);
}

// ✅ BETTER - use network() helper
final users = await network(
  request: () => get(...),
  throwOnError: true,
);
```

### Pitfall 3: Blocking Main Thread with Large Response Parsing
**Problem:** Parsing large JSON on UI thread  
**Solution:** Use compute() for heavy parsing

```dart
Future<ResponseModel<List<Product>>> getProducts() async {
  return await get<List<Product>>(
    '/products',
    decoder: (data) async {
      // Offload to isolate
      return await compute(_parseProducts, data);
    },
  );
}

List<Product> _parseProducts(dynamic data) {
  return (data as List).map((json) => Product.fromJson(json)).toList();
}
```

## Testing

### Unit Tests

```dart
void main() {
  group('MyApiService', () {
    late MockDio mockDio;
    late MyApiService api;

    setUp(() {
      mockDio = MockDio();
      api = MyApiService(mockRef);
      // Inject mock dio
    });

    test('getUsers returns parsed users', () async {
      when(mockDio.get('/users')).thenAnswer((_) async => Response(
        data: [{'id': 1, 'name': 'John'}],
        statusCode: 200,
      ));

      final response = await api.getUsers();

      expect(response.success, true);
      expect(response.data?.length, 1);
      expect(response.data?.first.name, 'John');
    });
  });
}
```

### Integration Tests

```dart
void main() {
  testWidgets('Fetches and displays users', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
  });
}
```

## Dependencies

### Internal Dependencies
- [Error Handling](./05_error_handling.md) - JetError integration
- [Dependency Injection](./02_dependency_injection.md) - Riverpod integration

### External Dependencies
- `dio: ^5.8.0+1` - HTTP client
- `hooks_riverpod: ^3.0.0` - Dependency injection

## Future Improvements

### Planned Enhancements
- [ ] Fix singleton memory leak with WeakReferences
- [ ] Remove global CancelToken
- [ ] Add request retry with exponential backoff
- [ ] Implement request deduplication
- [ ] Circuit breaker pattern for failing endpoints
- [ ] HTTP/2 support
- [ ] Request queueing for offline scenarios
- [ ] Response compression support

### Known Issues
- Singleton instances never released (memory leak)
- Global cancel token affects all requests
- No automatic retry mechanism
- Type detection uses runtime checks

## Related Documentation

- [Error Handling](./05_error_handling.md)
- [Interceptors](./06_interceptors.md)
- [Dependency Injection](./02_dependency_injection.md)
- [JetBuilder](./07_jet_builder.md) - Using with state

## FAQs

**Q: Should I create one API service or multiple?**  
A: Create separate services for different base URLs or domains (e.g., AuthApiService, DataApiService)

**Q: How do I add authentication?**  
A: Use a Bearer Token Interceptor or override defaultHeaders dynamically

**Q: Can I use it for GraphQL?**  
A: Yes, just POST to your GraphQL endpoint with query in body

**Q: How do I handle pagination?**  
A: Use JetPaginator with API service methods

**Q: What about WebSocket?**  
A: JetApiService is for HTTP only. Use Dio's WebSocket support directly or create a separate service.

---

**Contributors:** Jet Framework Team  
**Reviewers:** Core Team

