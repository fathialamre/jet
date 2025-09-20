import 'package:example/features/cache/models/cache_models.dart';
import 'package:example/features/cache/services/cache_service.dart';
import 'package:flutter/material.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';

/// Cache Example Page
///
/// Demonstrates various JetCache operations including:
/// - Writing data with TTL
/// - Reading cached data
/// - Managing different data types
/// - Cache statistics and cleanup
class CacheExamplePage extends StatelessWidget {
  const CacheExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jet Cache Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CacheStatsCard(),
            SizedBox(height: 16),
            _UserCacheSection(),
            SizedBox(height: 16),
            _ProductCacheSection(),
            SizedBox(height: 16),
            _SettingsCacheSection(),
            SizedBox(height: 16),
            _CacheManagementSection(),
          ],
        ),
      ),
    );
  }
}

/// Cache Statistics Card
class _CacheStatsCard extends StatelessWidget {
  const _CacheStatsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cache Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            FutureBuilder<Map<String, dynamic>>(
              future: CacheService.getStats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Column(
                    children: [
                      _StatRow(
                        'Total Entries',
                        stats['totalEntries'].toString(),
                      ),
                      _StatRow(
                        'Valid Entries',
                        stats['validEntries'].toString(),
                      ),
                      _StatRow(
                        'Expired Entries',
                        stats['expiredEntries'].toString(),
                      ),
                      _StatRow('Box Name', stats['boxName'].toString()),
                      _StatRow(
                        'Initialized',
                        stats['isInitialized'].toString(),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// User Cache Section
class _UserCacheSection extends StatelessWidget {
  const _UserCacheSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Cache (TTL: 30 seconds)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: JetButton(
                    text: 'Cache User',
                    onTap: () => _cacheUser(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JetButton.outlined(
                    text: 'Read User',
                    onTap: () => _readUser(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: JetButton.textButton(
                    text: 'Delete User',
                    onTap: () => _deleteUser(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JetButton.textButton(
                    text: 'Check Exists',
                    onTap: () => _checkUserExists(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cacheUser(BuildContext context) async {
    try {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        createdAt: DateTime.now(),
      );

      await CacheService.cacheUser(user);
      _showSnackBar(context, 'User cached successfully!');
    } catch (e) {
      _showSnackBar(context, 'Error caching user: $e');
    }
  }

  Future<void> _readUser(BuildContext context) async {
    try {
      final user = await CacheService.getUser();
      if (user != null) {
        _showSnackBar(context, 'User: ${user.name} (${user.email})');
      } else {
        _showSnackBar(context, 'No user found in cache');
      }
    } catch (e) {
      _showSnackBar(context, 'Error reading user: $e');
    }
  }

  Future<void> _deleteUser(BuildContext context) async {
    try {
      await CacheService.deleteUser();
      _showSnackBar(context, 'User deleted from cache');
    } catch (e) {
      _showSnackBar(context, 'Error deleting user: $e');
    }
  }

  Future<void> _checkUserExists(BuildContext context) async {
    try {
      final exists = await CacheService.userExists();
      _showSnackBar(context, 'User exists: $exists');
    } catch (e) {
      _showSnackBar(context, 'Error checking user: $e');
    }
  }
}

/// Product Cache Section
class _ProductCacheSection extends StatelessWidget {
  const _ProductCacheSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Cache (TTL: 1 minute)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: JetButton(
                    text: 'Cache Products',
                    onTap: () => _cacheProducts(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JetButton.outlined(
                    text: 'Read Products',
                    onTap: () => _readProducts(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: JetButton.textButton(
                    text: 'Delete Products',
                    onTap: () => _deleteProducts(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JetButton.textButton(
                    text: 'Check Exists',
                    onTap: () => _checkProductsExist(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cacheProducts(BuildContext context) async {
    try {
      final products = [
        Product(
          id: '1',
          name: 'Laptop',
          price: 999.99,
          category: 'Electronics',
          inStock: true,
        ),
        Product(
          id: '2',
          name: 'Phone',
          price: 699.99,
          category: 'Electronics',
          inStock: true,
        ),
        Product(
          id: '3',
          name: 'Book',
          price: 19.99,
          category: 'Books',
          inStock: false,
        ),
      ];

      await CacheService.cacheProducts(products);
      _showSnackBar(
        context,
        '${products.length} products cached successfully!',
      );
    } catch (e) {
      _showSnackBar(context, 'Error caching products: $e');
    }
  }

  Future<void> _readProducts(BuildContext context) async {
    try {
      final products = await CacheService.getProducts();
      if (products != null && products.isNotEmpty) {
        _showSnackBar(context, 'Found ${products.length} products in cache');
      } else {
        _showSnackBar(context, 'No products found in cache');
      }
    } catch (e) {
      _showSnackBar(context, 'Error reading products: $e');
    }
  }

  Future<void> _deleteProducts(BuildContext context) async {
    try {
      await CacheService.deleteProducts();
      _showSnackBar(context, 'Products deleted from cache');
    } catch (e) {
      _showSnackBar(context, 'Error deleting products: $e');
    }
  }

  Future<void> _checkProductsExist(BuildContext context) async {
    try {
      final exists = await CacheService.productsExist();
      _showSnackBar(context, 'Products exist: $exists');
    } catch (e) {
      _showSnackBar(context, 'Error checking products: $e');
    }
  }
}

/// Settings Cache Section
class _SettingsCacheSection extends StatelessWidget {
  const _SettingsCacheSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings Cache (No TTL)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: JetButton(
                    text: 'Cache Settings',
                    onTap: () => _cacheSettings(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JetButton.outlined(
                    text: 'Read Settings',
                    onTap: () => _readSettings(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: JetButton.textButton(
                    text: 'Delete Settings',
                    onTap: () => _deleteSettings(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JetButton.textButton(
                    text: 'Check Exists',
                    onTap: () => _checkSettingsExist(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cacheSettings(BuildContext context) async {
    try {
      final settings = AppSettings(
        theme: 'dark',
        language: 'en',
        notifications: true,
        autoSync: false,
        lastUpdated: DateTime.now(),
      );

      await CacheService.cacheSettings(settings);
      _showSnackBar(context, 'Settings cached successfully!');
    } catch (e) {
      _showSnackBar(context, 'Error caching settings: $e');
    }
  }

  Future<void> _readSettings(BuildContext context) async {
    try {
      final settings = await CacheService.getSettings();
      if (settings != null) {
        _showSnackBar(
          context,
          'Settings: ${settings.theme} theme, ${settings.language} language',
        );
      } else {
        _showSnackBar(context, 'No settings found in cache');
      }
    } catch (e) {
      _showSnackBar(context, 'Error reading settings: $e');
    }
  }

  Future<void> _deleteSettings(BuildContext context) async {
    try {
      await CacheService.deleteSettings();
      _showSnackBar(context, 'Settings deleted from cache');
    } catch (e) {
      _showSnackBar(context, 'Error deleting settings: $e');
    }
  }

  Future<void> _checkSettingsExist(BuildContext context) async {
    try {
      final exists = await CacheService.settingsExist();
      _showSnackBar(context, 'Settings exist: $exists');
    } catch (e) {
      _showSnackBar(context, 'Error checking settings: $e');
    }
  }
}

/// Cache Management Section
class _CacheManagementSection extends StatelessWidget {
  const _CacheManagementSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cache Management',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: JetButton(
                    text: 'Cleanup Expired',
                    onTap: () => _cleanupExpired(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JetButton.outlined(
                    text: 'Clear All',
                    onTap: () => _clearAll(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cleanupExpired(BuildContext context) async {
    try {
      final removedCount = await CacheService.cleanupExpired();
      _showSnackBar(context, 'Removed $removedCount expired entries');
    } catch (e) {
      _showSnackBar(context, 'Error cleaning up: $e');
    }
  }

  Future<void> _clearAll(BuildContext context) async {
    try {
      await CacheService.clearAll();
      _showSnackBar(context, 'All cache cleared');
    } catch (e) {
      _showSnackBar(context, 'Error clearing cache: $e');
    }
  }
}

/// Statistics Row Widget
class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show snackbar
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
