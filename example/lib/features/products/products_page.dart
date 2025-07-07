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
      body: JetPaginator.grid<Product, PaginationResponse<Product>>(
        firstPageKey: 0,
        crossAxisCount: 2,
        fetchPage: (pageKey) async {
          // Use the existing provider family
          final int skip = pageKey as int;
          return await ref.read(
            productsProvider(skip).future,
          );
        },
        parseResponse: (response, currentPageKey) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                product.thumbnail,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text(product.title, style: const TextStyle(fontSize: 16)),
              Text(
                product.price.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      ),
    );
  }
}
