import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart' hide PageInfo;
import 'package:jet/resources/state.dart';
import '../../models/product.dart';
import 'notifiers/products_notifier.dart';

/// Products page with infinite scroll using the new unified JetPaginator API
///
/// This example demonstrates:
/// - Using JetPaginator.list for infinite scroll lists
/// - Working with any API pagination format (DummyJSON in this case)
/// - Automatic pull-to-refresh and error handling
/// - Clean response parsing with PageInfo
/// - Beautiful card-based UI with product details
/// - Provider integration for Riverpod invalidate functionality
class ProductsPage extends JetConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Products'),
        actions: [
          // Add refresh button to demonstrate invalidate
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // For family providers, we invalidate the entire family
              ref.invalidate(productsProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Products refreshed!')),
              );
            },
          ),
        ],
      ),
      body: JetPaginator.list<Product, PaginationResponse<Product>>(
        // Note: Provider integration is not used here because productsProvider
        // is a family provider. For family providers, you can still manually
        // invalidate using ref.invalidate(productsProvider) as shown above.
        // For non-family providers, you can pass: provider: yourProvider
        firstPageKey: 0,
        fetchPage: (pageKey) async {
          // Use the existing provider family
          final int skip = pageKey as int;
          return await ref.read(
            productsProvider(skip).future,
          );
        },
        parseResponse: (response, currentPageKey) {
          print('====response ${response}');
          print('====response ${currentPageKey}');
          // Parse the PaginationResponse into PageInfo for JetPaginator
          return PageInfo<Product>(
            items: response.items,
            nextPageKey: response.nextPageKey,
            isLastPage: response.isLastPage,
            totalItems: response.total,
          );
        },
        itemBuilder: (product, index) => Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                product.thumbnail,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              ),
            ),
            title: Text(product.title),
            subtitle: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            trailing: Text(
              'Rating: ${product.rating.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped: ${product.title}')),
              );
            },
          ),
        ),

        // Customization
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      ),
    );
  }
}
