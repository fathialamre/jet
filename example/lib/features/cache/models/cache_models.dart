/// Cache Models for Jet Cache Example
///
/// This file contains various model classes to demonstrate
/// different data types that can be cached using JetCache.

/// User model for caching user data
class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  /// Convert User to Map for caching
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  /// Create User from Map (from cache)
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
  );

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;
}

/// Product model for caching product data
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.inStock,
  });

  /// Convert Product to Map for caching
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'category': category,
    'inStock': inStock,
  };

  /// Create Product from Map (from cache)
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    category: json['category'] as String,
    inStock: json['inStock'] as bool,
  );

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          category == other.category &&
          inStock == other.inStock;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      category.hashCode ^
      inStock.hashCode;
}

/// App Settings model for caching application settings
class AppSettings {
  final String theme;
  final String language;
  final bool notifications;
  final bool autoSync;
  final DateTime lastUpdated;

  const AppSettings({
    required this.theme,
    required this.language,
    required this.notifications,
    required this.autoSync,
    required this.lastUpdated,
  });

  /// Convert AppSettings to Map for caching
  Map<String, dynamic> toJson() => {
    'theme': theme,
    'language': language,
    'notifications': notifications,
    'autoSync': autoSync,
    'lastUpdated': lastUpdated.millisecondsSinceEpoch,
  };

  /// Create AppSettings from Map (from cache)
  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    theme: json['theme'] as String,
    language: json['language'] as String,
    notifications: json['notifications'] as bool,
    autoSync: json['autoSync'] as bool,
    lastUpdated: DateTime.fromMillisecondsSinceEpoch(
      json['lastUpdated'] as int,
    ),
  );

  @override
  String toString() =>
      'AppSettings(theme: $theme, language: $language, notifications: $notifications)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          theme == other.theme &&
          language == other.language &&
          notifications == other.notifications &&
          autoSync == other.autoSync;

  @override
  int get hashCode =>
      theme.hashCode ^
      language.hashCode ^
      notifications.hashCode ^
      autoSync.hashCode;
}

/// Cache Keys constants
class CacheKeys {
  static const String user = 'user_data';
  static const String products = 'products_list';
  static const String settings = 'app_settings';

  // Private constructor to prevent instantiation
  CacheKeys._();
}

/// Cache TTL constants
class CacheTTL {
  static const Duration user = Duration(seconds: 30);
  static const Duration products = Duration(minutes: 1);
  static const Duration settings = Duration(days: 30);

  // Private constructor to prevent instantiation
  CacheTTL._();
}
