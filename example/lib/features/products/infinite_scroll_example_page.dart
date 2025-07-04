import 'package:flutter/material.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/jet_pagination_helpers.dart';
import 'package:jet/resources/state/models/pagination_response.dart';
import '../../models/product.dart';
import 'notifiers/products_notifier.dart';

/// Products page with infinite scroll using Jet's pagination helpers
class InfiniteScrollExamplePage extends ConsumerWidget {
  const InfiniteScrollExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Demo 22'),
      ),
      body:
          JetPaginationHelpers.infiniteList<
            Product,
            PaginationResponse<Product>
          >(
            fetchPage: (pageKey) async {
              return await ref.read(
                productsProvider(pageKey as int).future,
              );
            },
            itemBuilder: (product, index) => Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.thumbnail,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                title: Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            Text(product.rating.toStringAsFixed(1)),
                          ],
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            product.category,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.blue[100],
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  // Show simple snackbar with product info
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.title} - \$${product.price}',
                      ),
                    ),
                  );
                },
              ),
            ),
            // Basic configuration
            firstPageKey: 0, // Start with skip=0
            enablePullToRefresh: true,
            padding: const EdgeInsets.only(bottom: 16),
            responseParser:
                (PaginationResponse<Product> response, dynamic currentPageKey) {
                  return PaginationInfo(
                    items: response.items,
                    nextPageKey: response.nextPageKey,
                  );
                },

            // Optional: Custom loading and error indicators
            // firstPageProgressIndicator: Center(
            //   child: CircularProgressIndicator(),
            // ),
            // newPageProgressIndicator: Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Center(child: CircularProgressIndicator()),
            // ),
            // firstPageErrorIndicator: Center(
            //   child: Text('Failed to load products'),
            // ),
            // noItemsFoundIndicator: Center(
            //   child: Text('No products found'),
            // ),

            // Optional: Callbacks
            // onRefresh: () {
            //   // Custom refresh logic
            //   print('Refreshing products...');
            // },
            // onRetry: () {
            //   // Custom retry logic
            //   print('Retrying...');
            // },

            // Optional: Performance tuning
            // invisibleItemsThreshold: 3, // Load more when 3 items from bottom
          ),
    );
  }
}
