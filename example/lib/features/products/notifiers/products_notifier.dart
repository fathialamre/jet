import 'package:dio/dio.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/resources/state/models.dart';
import '../../../models/product.dart';

// Updated to support pagination with skip parameter
final productsProvider =
    AutoDisposeFutureProvider.family<PaginationResponse<Product>, int>(
      (ref, skip) async {
        print('====done $skip');
        // DummyJSON API call with pagination
        final dio = Dio();
        final response = await dio.get(
          'https://dummyjson.com/products?limit=20&skip=$skip',
        );

        // Use the convenient fromDummyJson factory
        return PaginationResponse.fromDummyJson(
          response.data,
          (json) => Product.fromJson(json),
          'products',
        );
      },
    );
