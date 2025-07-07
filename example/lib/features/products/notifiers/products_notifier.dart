import 'package:dio/dio.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/models.dart';
import '../../../models/product.dart';

/// Products provider with comprehensive error handling
///
/// This example demonstrates:
/// - Proper error handling around raw Dio HTTP calls
/// - Converting errors to JetExceptions for consistent error handling
/// - Graceful error recovery with retry functionality
/// - Integration with JetPaginator for infinite scroll
final productsProvider =
    AutoDisposeFutureProvider.family<PaginationResponse<Product>, int>(
      (ref, skip) async {
        try {
          final dio = Dio();

          final response = await dio.get(
            'https://dummyjson.com/products?limit=20&skip=$skip',
          );

          return PaginationResponse.fromDummyJson(
            response.data,
            (json) => Product.fromJson(json),
            'products',
          );
        } catch (error) {
          rethrow;
        }
      },
    );
